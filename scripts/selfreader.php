<?php
/**
 * read self contents 'without' file reading functoins
 */
echo str_replace('<?php', "<?php\n", html_entity_decode(strip_tags(highlight_file(__FILE__, true))));
