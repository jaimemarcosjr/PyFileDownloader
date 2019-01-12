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
        <a class="nav-link" href="/">Download</a>
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
          <ul class="list-group">
            % for item in list:
            <li class="list-group-item d-flex justify-content-between align-items-center">
              {{item}}
              <span class="badge badge-pill">
                <a href="/remove/{{item}}">
                  <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
                    <path d="M0 0h24v24H0z" fill="none" />
                    <path d="M7 11v2h10v-2H7zm5-9C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8z" /></svg>
                </a>
              </span>
            </li>
            % end
          </ul>
        </div>
        <div class="card-footer">

        </div>
      </div>
    </div>
    <div class="progress" id="progress" style="height: 33px;">
      <div class="progress-bar progress-bar-striped" style="width:0; height: 33px;"><span></span></div>
    </div>
  </div>

</body>
<script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.6/umd/popper.min.js" integrity="sha384-wHAiFfRlMFy6i5SRaxvfOCifBUQy1xHdJ/yoi7FRNXMRBu5WHdZYu1hA6ZOblgut" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/js/bootstrap.min.js" integrity="sha384-B0UglyR+jN6CkvvICOB2joaf5I4l3gm9GU6Hc1og6Ls7i6U/mkkaduKaBhlAXv9k" crossorigin="anonymous"></script>
<script type="text/javascript">
  $(document).ready(function() {
    % if res == "deleted":
      alert("File removed!");
    % elif res == "notfound":
      alert("File not found!");
    % end
  });
</script>

</html>
