<?php /* @var $this Controller */ ?>

Hello, <?php echo ucfirst(Yii::app()->user->name) ?>

<p>To logout click <a href="<?php echo $this->createUrl('site/logout');?>">here</a>.</p>