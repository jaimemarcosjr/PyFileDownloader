import sqlite3


class pref:
    def __init__(self):
        self.conn = sqlite3.connect('pr.db')
        self.c = self.conn.cursor()
        self.c.execute('''CREATE TABLE IF NOT EXISTS conf
             (name text, value text)''')
        self.conn.commit()

    def getPath(self):
        t = ("path", )
        selectResult = self.__select(t)
        if (str(selectResult) == "None"):
            print("None")
            return ""
        else:
            return selectResult[1]

    def login(self, value):
        t = ("pass", value)
        self.c.execute('SELECT COUNT(*) FROM conf WHERE name=? and value=?', t)
        r = self.c.fetchone()
        return int(str(r[0]))

    def checkPassAndPathExist(self):
        resPath = int(self.__checkNameExists("path"))
        resPass = int(self.__checkNameExists("pass"))
        if (resPath == 1 and resPass == 1):
            return True
        else:
            return False

    def savePassword(self, value):
        res = self.__checkNameExists("pass")
        print(res)
        if (int(res) == 1):
            t = (value, "pass")
            self.__update(t)
        elif (int(res) == 0):
            t = ("pass", value)
            self.__insert(t)
        elif (int(res) > 1):
            t = ("pass", )
            self.__delete(t)
            t = ("pass", value)
            self.__insert(t)
        self.conn.commit()

    def savePath(self, value):
        res = self.__checkNameExists("path")
        print(res)
        if (int(res) == 1):
            t = (value, "path")
            self.__update(t)
        elif (int(res) == 0):
            t = ("path", value)
            self.__insert(t)
        elif (int(res) > 1):
            t = ("path", )
            self.__delete(t)
            t = ("path", value)
            self.__insert(t)
        self.conn.commit()

    def __select(self, t):
        self.c.execute('SELECT * FROM conf WHERE name=?', t)
        return self.c.fetchone()

    def __delete(self, t):
        self.c.execute("DELETE FROM conf WHERE name =  ?", t)
        print("")

    def __update(self, t):
        self.c.execute("UPDATE conf SET value = ? WHERE name = ?", t)
        print("update")

    def __insert(self, t):
        self.c.execute("INSERT INTO conf VALUES (?, ? )", t)
        print("insert")

    def __checkNameExists(self, name):
        t = (name, )
        self.c.execute('SELECT COUNT(*) FROM conf WHERE name=?', t)
        r = self.c.fetchone()
        res = str(r[0])
        return res
