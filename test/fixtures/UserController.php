<?php

// Example of amateur php code
class UserController extends Base
{

  public $currentUser;

  public function login()
  {

  $this->currentUser = new User();

      // if the user is logged in (the session var is set) then just fill in user
      if ($this->modSession("get", "loggedin") == "true")
      {
          $id = $this->modSession("get", "id");
          $this->currentUser->setUser($id);
      }
      else
      {

          $username = $_POST["username"];
          $password = $_POST["password"];

          //render login if user not logged in
          if (empty($username) && empty($password))
          {
            $this->renderView("admin/login");
          }
          elseif ($this->currentUser->login($username, $password) == false)
          {
            $this->flash = "Incorrect user name or password";
            $this->renderView("admin/login");
          }
          else
          {
              $this->modSession("add", "id", $this->currentUser->id);
              $this->modSession("add", "loggedin", "true");
              //$this->modSession("add", "admin", "true");
              $this->flash = "Successfully Logged In";
              $this->renderView("home");
          }

      }

  }

  public function logout(){
    $this->modSession("destroy");
  }

}

