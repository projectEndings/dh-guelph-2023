/**
 * Very simple javascript additions
 */


function improveLinks(){
    const links = document.querySelectorAll('a[href^="http"]');
    links.forEach(link => {
        link.setAttribute('target','_blank');
        link.setAttribute('rel','nofollow;noreferrer');
    });
    return true;
}

function init(){
  improveLinks();
}

 /**
  * Initialize on DOM Loaded
  * 
  */
 document.addEventListener('DOMContentLoaded', init);
 

 
 
 