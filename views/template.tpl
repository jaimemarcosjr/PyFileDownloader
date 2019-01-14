<html>
  <head>
    <title>{{title}}</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css" integrity="sha384-GJzZqFGwb1QTTN6wy59ffF1BuGJpLSa9DkKMp0DgiMDm4iYMj70gZWKYbI706tWS" crossorigin="anonymous">
    <style media="screen">
    .boxshadow {
    box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);3);
    width: 500px;
    }
    .boxshadow .card > * > *{
    margin: 0 4px;
    margin-top: 4px;
    }
    .progress{
    width: 60%;
    margin: auto;
    }
    </style>
  </head>
  <body>
    <nav class="navbar navbar-expand-sm bg-primary navbar-dark">
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link" href="#" data-toggle="modal" data-target="#changepassmodal">Change Pass</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#" data-toggle="modal" data-target="#changepathmodal">Change Directory</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="/list">List Directory</a>
        </li>
      </ul>
    </nav>
    <div class="container">
      <div class="boxshadow" style="margin: 20px auto; ">
        <div class="card">
          <div class="card-header bg-primary text-white">
            <h1 class="text-center">{{title}}</h1>
            <p class="text-center">{{content}}</p>
          </div>
          <div class="card-body bg-light text-dark">
            <form id="formurl" action="#">
              <div class="form-group">
                <input type="text" class="form-control" id="url" name="url" placeholder="Url..">
              </div>
              <div class="text-center">
                <button type="submit" style="margin: 0 auto;" class="btn btn-primary">Submit</button>
              </div>
            </form>
          </div>
          <div class="card-footer">
            <span id="filename"></span>
          </div>
        </div>
      </div>
      <div class="progress" id="progress" style="height: 33px;">
        <div class="progress-bar progress-bar-striped" style="width:0; height: 33px;"><span></span></div>
      </div>
    </div>
    <div class="modal fade" id="changepathmodal">
      <div class="modal-dialog">
        <div class="modal-content">
          <!-- Modal Header -->
          <div class="modal-header">
            <h4 class="modal-title">Change Path</h4>
            <button type="button" class="close" data-dismiss="modal">&times;</button>
          </div>
          <!-- Modal body -->
          <div class="modal-body">
            <form id="formcpath" method="post" action="/changepath">
              <div class="form-group">
                <input type="text" class="form-control" id="path" value="{{path}}" name="path" placeholder="Path..." required>
              </div>
              <div class="form-group">
                <input type="password" class="form-control" id="pass" name="pass" placeholder="Password..." required>
              </div>
              <div class="text-center">
                <button type="submit" style="margin: 0 auto;" class="btn btn-primary">Submit</button>
              </div>
            </form>
          </div>
          <!-- Modal footer -->
          <div class="modal-footer">
          </div>
        </div>
      </div>
    </div>
    <div class="modal fade" id="changepassmodal">
      <div class="modal-dialog">
        <div class="modal-content">
          <!-- Modal Header -->
          <div class="modal-header">
            <h4 class="modal-title">Change Password</h4>
            <button type="button" class="close" data-dismiss="modal">&times;</button>
          </div>
          <!-- Modal body -->
          <div class="modal-body">
            <form id="formcpass" method="post" action="/changepass">
              <div class="form-group">
                <input type="password" class="form-control" id="curpass" name="curpass" placeholder="Current Password..." required>
              </div>
              <div class="form-group">
                <input type="password" class="form-control" id="chpass" name="chpass" placeholder="Password..." required>
              </div>
              <div class="form-group">
                <input type="password" class="form-control" id="cpass" name="cpass" placeholder="Confirm Password..." required>
              </div>
              <div class="text-center">
                <button type="submit" style="margin: 0 auto;" class="btn btn-primary">Submit</button>
              </div>
            </form>
          </div>
          <!-- Modal footer -->
          <div class="modal-footer">
          </div>
        </div>
      </div>
    </div>
  </body>
  <script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.6/umd/popper.min.js" integrity="sha384-wHAiFfRlMFy6i5SRaxvfOCifBUQy1xHdJ/yoi7FRNXMRBu5WHdZYu1hA6ZOblgut" crossorigin="anonymous"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/js/bootstrap.min.js" integrity="sha384-B0UglyR+jN6CkvvICOB2joaf5I4l3gm9GU6Hc1og6Ls7i6U/mkkaduKaBhlAXv9k" crossorigin="anonymous"></script>
  <script type="text/javascript">
  $(document).ready(function() {
  let isDownloading = false;
  url = "ws://" + window.location.host + "/dlprogress"
  ws = new WebSocket(url); //this must be changed according to the remote server's address
  ws.onopen = function() {
  ws.send("Hello, world");
  };
  ws.onmessage = function(evt) {
  res = JSON.parse(evt.data);
  if (res.error !== undefined && res.error !== null) {
  console.log(res.error);
  return;
  }
  if (parseFloat(res.current_percent) > 0 && 1 > parseFloat(res.current_percent)) {
  isDownloading = true;
  }
  $("#filename").html(res.file_name);
  $("#progress > div > span ").html(parseFloat(res.current_percent).toFixed(2) + "% <br/> (" + res.current_dl + "KB/" + res.total_size + "KB)");
  $("#progress > div").css("width", res.current_percent + "%");
  if (parseInt(res.current_percent) === 100) {
  alert("Download complete!");
  $("#progress > div").css("width", "0");
  $("#progress > div > span ").html("");
  $("#filename").html("");
  $("#url").val("");
  isDownloading = false;
  }
  };
  ws.onclose = function() {
  console.log("close");
  };
  $("#formurl").submit(function(event) {
  event.preventDefault();
  url = $("#url").val();
  if (url === "") {
  return;
  }
  if (isDownloading) {
  alert("Downloading!");
  return;
  }
  ws.send(url);
  });
  $("#formcpass").submit(function(event) {
  event.preventDefault();
  var $form = $(this),
  cpass = $form.find("input[name='cpass']").val(),
  curpass = $form.find("input[name='curpass']").val(),
  chpass = $form.find("input[name='chpass']").val(),
  url = $form.attr("action");
  var posting = $.post(url, {
  cpass: cpass,
  curpass: curpass,
  chpass: chpass
  });
  posting.done(function(data) {
  res = JSON.parse(data);
  if (res.result === 'error') {
  if (res.message === "wrong_pass") {
  alert("Wrong current password.");
  } else if (res.message === "not_match") {
  alert("Password don't match.");
  }
  } else if (res.result === 'success') {
  console.log(res.message);
  alert("Password changed.");
  $("#changepassmodal").modal("hide");
  $form.find("input[name='cpass']").val("")
  $form.find("input[name='curpass']").val("")
  $form.find("input[name='chpass']").val("")
  }
  });
  posting.fail(function() {
  alert("error. Somethong went wrong.");
  })
  });
  $("#formcpath").submit(function(event) {
  event.preventDefault();
  var $form = $(this),
  path = $form.find("input[name='path']").val(),
  pass = $form.find("input[name='pass']").val(),
  url = $form.attr("action");
  var posting = $.post(url, {
  path: path,
  pass: pass
  });
  posting.done(function(data) {
  res = JSON.parse(data);
  if (res.result === 'error') {
  alert("Wrong current password.");
  } else if (res.result === 'success') {
  console.log(res.message);
  alert("Path changed.");
  $("#changepathmodal").modal("hide");
  $form.find("input[name='path']").val("")
  $form.find("input[name='pass']").val("")
  }
  });
  posting.fail(function() {
  alert("error. Somethong went wrong.");
  })
  });
  });
  </script>
</html>