<?php

class SiteController extends Controller {

    const LOGIN_ATTEMPS_KEY = 'loginAttempts';
    const LOGIN_BAN_TIME_KEY = 'loginBan';
    const LOGIN_BAN_DURATION = 300; // 5 minits 5*60 seconds 
    const MAX_LOGIN_ATTEMPTS = 3;

    public $defaultAction = 'profile';

    public function filters() {
        return array(
            'accessControl',
        );
    }

    public function accessRules() {
        return array(
            array('deny',
                'actions' => array('profile'),
                'users' => array('?')
            ),
        );
    }

    public function actionProfile() {
        $this->render('profile');
    }

    /**
     * This is the action to handle external exceptions.
     */
    public function actionError() {
        if ($error = Yii::app()->errorHandler->error) {
            if (Yii::app()->request->isAjaxRequest)
                echo $error['message'];
            else
                $this->render('error', $error);
        }
    }

    public function actionBan() {
        $timeLeft = self::LOGIN_BAN_DURATION - (time() - Yii::app()->session->itemAt(self::LOGIN_BAN_TIME_KEY));
        if ($timeLeft <= 0) {
            $this->redirect('login');
        }
        $this->render('ban', array('banTimeLeft' => $timeLeft));
    }

    /**
     * Displays the login page
     */
    public function actionLogin() {
        if (!Yii::app()->user->isGuest) {
            $this->redirect('profile');
        }
        $model = $this->isLoginAllowed() ? new LoginForm : null;
        if (!$this->isLoginAllowed()) {
            $this->redirect('ban');
            return;
        }
        // if it is ajax validation request
        if (isset($_POST['ajax']) && $_POST['ajax'] === 'login-form') {
            echo CActiveForm::validate($model);
            Yii::app()->end();
        }

        // collect user input data
        if (isset($_POST['LoginForm'])) {
            $model->attributes = $_POST['LoginForm'];
            // validate user input and redirect to the previous page if valid
            if ($model->validate() && $model->login()) {
                // clear login attemts counter
                Yii::app()->session->offsetUnset(self::LOGIN_ATTEMPS_KEY);
                $this->redirect(Yii::app()->user->returnUrl);
            } else {
                // increment login attemps counter
                $loginAttempts = Yii::app()->session->itemAt(self::LOGIN_ATTEMPS_KEY) + 1;
                Yii::app()->session->add(self::LOGIN_ATTEMPS_KEY, $loginAttempts);
                // if login attempts reach max login attempts - ban login for ban timeout
                if ($loginAttempts >= self::MAX_LOGIN_ATTEMPTS) {
                    Yii::app()->session->add(self::LOGIN_BAN_TIME_KEY, time());
                }
            }
        }
        // display the login form
        $this->render('login', array('model' => $model));
    }

    /**
     * Logs out the current user and redirect to homepage.
     */
    public function actionLogout() {
        Yii::app()->user->logout();
        $this->redirect(Yii::app()->homeUrl);
    }

    /**
     * check if login function is not banned
     * @return boolean
     */
    private function isLoginAllowed() {
        // check if ban timer set
        if (Yii::app()->session->offsetExists(self::LOGIN_BAN_TIME_KEY)) {

            // check if ban timer actual
            if ((time() - Yii::app()->session->itemAt(self::LOGIN_BAN_TIME_KEY)) < self::LOGIN_BAN_DURATION
            ) {

                return false;
            }
            // clear ban timer
            Yii::app()->session->offsetUnset(self::LOGIN_BAN_TIME_KEY);
            Yii::app()->session->offsetUnset(self::LOGIN_ATTEMPS_KEY);
        }
        return true;
    }

}