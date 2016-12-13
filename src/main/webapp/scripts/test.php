<!--
<?php

function quercus_test()
{
    return function_exists("quercus_version");
}

?>
-->
<?php
$paramRequest = $request->getAttribute('paramRequest');
$user=$paramRequest->getUser();
$webpage=$paramRequest->getTopic();
?>
FullName:<?php echo $user->getFullName(); ?><br/>
Email:<?php echo $user->getEmail(); ?><br/>
WebPage:<?php echo $webpage->getDisplayName(); ?><br/>
Path:<?php echo $webpage->getPath(); ?><br/>

<div class="message" id="success">
    Quercus&#153; <?php if (quercus_test()) echo quercus_version(); ?> seems to be working fine.  Have fun!
</div>