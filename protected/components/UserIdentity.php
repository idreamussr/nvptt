<?php

/**
 * UserIdentity represents the data needed to identity a user.
 * It contains the authentication method that checks if the provided
 * data can identity the user.
 */
class UserIdentity extends CUserIdentity {

    private $_id;

    /**
     * Authenticates a user.
     * @return boolean whether authentication succeeds.
     */
    public function authenticate() {
        // open users db file
        $fileHandle = fopen(Yii::app()->params['usersStoragePath'], 'r');
        
        // read columns metadata
        $names = fgetcsv($fileHandle, 1024);
        $names = array_flip($names);
        // iterate through users to find match
        while (!feof($fileHandle) ) {
            $data = fgetcsv($fileHandle, 1024);
            if($data[$names['username']] == $this->username
                    AND $data[$names['password']] == $this->password
              ) {
                // break if match found
                $this->_id = $data[$names['id']];
                break;
            }
        }
        fclose($fileHandle);
        // if no match
        if(empty($this->_id)) {
            $this->errorCode = self::ERROR_UNKNOWN_IDENTITY;
        } else {
            $this->errorCode = self::ERROR_NONE;
        }
        return !$this->errorCode;
    }
    
    public function getId() {
        return $this->_id;
    }
}