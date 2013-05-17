<?php
/* @var $this SiteController */
?>

<h1>Login restricted</h1>

<p>You cannot login at this time. Please try login later after 
<strong><?php if ($banTimeLeft > 60): ?>
        <?php echo gmdate('i', $banTimeLeft); ?> minutes <?php endif ?>
    <?php echo gmdate('s', $banTimeLeft); ?> seconds</strong> 
</p>
