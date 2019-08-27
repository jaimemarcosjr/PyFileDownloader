from gevent.pywsgi import WSGIServer
from geventwebsocket.handler import WebSocketHandler
from geventwebsocket import WebSocketError
from pref import pref
from pathlib2 import Path
from bottle import Bottle, run, template, request, abort, redirect, response
import urllib2, httplib, json, os, shutil, binascii

pr = pref()
app = Bottle()


def dumpJSON(data):
    return json.dumps(data, sort_keys=True, indent=4, separators=(',', ': '))


@app.route('/hello/<name>')
def index(name):
    return template('<b>Hello {{name}}</b>!', name=name)


@app.route('/hi/<name>/<action>/<user>')
def index(name, action, user):
    return template(
        '<b>Hi {{name}} {{action}} {{user}}</b>!',
        name=name,
        action=action,
        user=user)


@app.route('/changepass', method='POST')
def do_changepass():
    if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        cpass = request.forms.get('cpass').strip()
        curpass = request.forms.get('curpass').strip()
        chpass = request.forms.get('chpass').strip()
        if pr.login(curpass) == 1:
            if cpass != chpass:
                return dumpJSON({'result': 'error', 'message': 'not_match'})
            pr.savePassword(cpass)
            return dumpJSON({'result': 'success', 'message': 'pass_changed'})
        else:
            return dumpJSON({'result': 'error', 'message': 'wrong_pass'})


@app.route('/changepath', method='POST')
def do_changepass():
    if request.headers.get('X-Requested-With') == 'XMLHttpRequest':
        path = request.forms.get('path').strip()
        password = request.forms.get('pass').strip()
        if pr.login(password) == 1:
            pr.savePath(path)
            return dumpJSON({'result': 'success', 'message': 'path_changed'})
        else:
            return dumpJSON({'result': 'error', 'message': 'wrong_pass'})


@app.route('/login', method='POST')
def do_login():
    password = request.forms.get('pass').strip()
    if password == "":
        return redirect("/login/incomplete")
    if pr.login(password) == 0:
        return redirect("/login/notmatch")
    response.set_cookie("logged_in", "yes")
    redirect("/")


@app.route('/login/<status>')
def index(status):
    """Setup page"""
    footer = ''
    if status == "notmatch":
        print(status)
        footer = '''<div class="alert alert-danger alert-dismissible fade show">
                <button type="button" class="close" data-dismiss = "alert" > &times; </button >
                <strong > Error!</strong > Password is incorrect!
            </div>'''
    elif status == "incomplete":
        footer = '''<div class="alert alert-warning alert-dismissible fade show">
                <button type="button" class="close" data-dismiss = "alert" > &times; </button >
                <strong > Warning!</strong > Fill up all form!
            </div>'''
    info = {
        'title': 'Login',
        'content': 'Please provide your password.',
        'footer': footer
    }

    return template('login.tpl', info)


@app.route('/setup', method='POST')
def do_setup():
    path = request.forms.get('path').strip()
    password = request.forms.get('pass').strip()
    cpass = request.forms.get('cpass').strip()
    p = bin(int(binascii.hexlify(path), 16)) 
    if path == "" or password == "" or cpass == "":
        return redirect("/setup/incomplete/" + p)
    if cpass != password:
        return redirect("/setup/notmatch/" + p )
    pr.savePath(path)
    pr.savePassword(password)
    redirect("/")


@app.route('/setup/<status>/<path>')
@app.route('/setup/<status>')
def index(status, path=""):
    """Setup page"""
    n = int(path, 2)
    path = binascii.unhexlify('%x' % n)
    footer = ''
    if status == "notmatch":
        print(status)
        footer = '''<div class="alert alert-danger alert-dismissible fade show">
                <button type="button" class="close" data-dismiss = "alert" > &times; </button >
                <strong > Error!</strong > Password don't match!
            </div>'''
    elif status == "incomplete":
        footer = '''<div class="alert alert-warning alert-dismissible fade show">
                <button type="button" class="close" data-dismiss = "alert" > &times; </button >
                <strong > Warning!</strong > Fill up all form!
            </div>'''
    info = {
        'title':
        'Setup!',
        'content':
        'You will input a password for the web app and path to save the files.',
        'footer':
        footer,
        'path':
        path
    }
    return template('setup.tpl', info)


@app.route('/remove/<item>')
def index(item=""):
    file = str(Path(pr.getPath())) + "/" + item
    try:
        os.remove(file)
        redirect("/list/deleted")
    except OSError as e:
        if e.errno == 21:
            shutil.rmtree(file)
            redirect("/list/deleted")
        redirect("/list/notfound")


@app.route('/list/<status>')
@app.route('/list')
def index(status=""):
    if (pr.checkPassAndPathExist()):
        if not request.get_cookie("logged_in"):
            redirect("/login/1")
        """Home page"""
        info = {
            'title':
            'Directory list',
            'content':
            'This is all your item downloaded. You can remove your item here.',
            'list':
            os.listdir(str(Path(pr.getPath()))),
            'res':
            status
        }
        return template('list.tpl', info)
    else:
        redirect("/setup/1")


@app.route('/')
def index():
    if (pr.checkPassAndPathExist()):
        if not request.get_cookie("logged_in"):
            redirect("/login/1")
        """Home page"""
        info = {
            'title': 'Welcome Home!',
            'content': 'Paste your url to download the file to server.',
            'path': pr.getPath()
        }

        return template('template.tpl', info)
    else:
        redirect("/setup/1")


@app.route('/dlprogress')
def handle_websocket():
    wsock = request.environ.get('wsgi.websocket')
    if not wsock:
        abort(400, 'Expected WebSocket request.')
    while True:
        try:
            url = wsock.receive()
            file_name = url.split('/')[-1]
            u = urllib2.urlopen(url)
            f = open(str(Path(pr.getPath())) + "/" + file_name, 'wb')
            meta = u.info()
            file_size = int(meta.getheaders("Content-Length")[0])
            total_size = "{0:.2f}".format(file_size / float(1000.00))
            file_size_dl = 0
            block_sz = 1024000 * 3
            while True:
                buffer = u.read(block_sz)
                if not buffer:
                    break
                file_size_dl += len(buffer)
                f.write(buffer)
                current_dl = "{0:.2f}".format((file_size_dl / float(1000.00)))
                current_percent = "{0:.10f}".format(
                    (file_size_dl * 100. / file_size))
                status = dumpJSON({
                    'file_name': file_name,
                    'current_dl': current_dl,
                    'current_percent': current_percent,
                    'total_size': total_size
                })
                wsock.send(status)
            f.close()
        except WebSocketError:
            break
        except urllib2.HTTPError as e:
            wsock.send(dumpJSON({"error": "HTTPError", "code": str(e.code)}))
            print str(e.code)
        except urllib2.URLError as e:
            wsock.send(dumpJSON({"error": "URLError"}))
        except httplib.HTTPException as e:
            wsock.send(dumpJSON({"error": "HTTPException"}))
        except ValueError as e:
            wsock.send(dumpJSON({"error": "ValueError"}))
        except IOError as e:
            wsock.send(dumpJSON({"error": "IOError"}))
        except ZeroDivisionError as e:
            wsock.send(dumpJSON({"error": "ZeroDivisionError"}))
        except Exception as e:
            wsock.send(dumpJSON({"error": "generic"}))


server = WSGIServer(("127.0.0.1", 8090), app, handler_class=WebSocketHandler)
server.serve_forever()
