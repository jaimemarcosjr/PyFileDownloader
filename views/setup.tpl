<html>

<head>
  <title>{{title}}</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
  <style media="screen">
  .boxshadow {
      box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);3);
      width: 500px;
      margin: auto;
  }
  .boxshadow .card > * > *{
    margin: 0 4px;
    margin-top: 4px;
  }
  </style>
</head>
<body>
  <div class="container">
    <div class="boxshadow" style="margin-top: 20px;">
      <div class="card">
        <div class="card-header bg-primary text-white">
          <h1 class="text-center">{{title}}</h1>
          <p class="text-center">{{content}}</p>
        </div>
        <div class="card-body bg-light text-dark">
          <form id="formsetup" method="post" action="/setup">
            <div class="form-group">
              <input type="text" class="form-control" id="path" name="path" placeholder="Path..." required>
            </div>
            <div class="form-group">
              <input type="password" class="form-control" id="pass" name="pass" placeholder="Password..." required>
            </div>
            <div class="form-group">
              <input type="password" class="form-control" id="cpass" name="cpass" placeholder="Confirm Password..." required>
            </div>
            <div class="text-center">
              <button type="submit" style="margin: 0 auto;" class="btn btn-primary">Submit</button>
            </div>
          </form>
        </div>
        <div class="card-footer">
          {{!footer}}
        </div>
      </div>
    </div>
  </div>

</body>
<script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
<script type="text/javascript">
</script>

</html>
