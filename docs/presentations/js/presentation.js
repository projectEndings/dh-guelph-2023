import Reveal from '../reveal.js/dist/reveal.esm.js';
import Markdown from '../reveal.js/plugin/markdown/markdown.esm.js';
import Highlight from '../reveal.js/plugin/highlight/highlight.esm.js';

// First get the markdown slide and make it so:

let markdownSlide = document.querySelector('section#md_eg');
let md = new Markdown();

let deck = new Reveal({
    plugins: [ Markdown, Highlight ]
});

deck.initialize({
    hash: true,
    maxScale: 1.5
});

let open;
let bigListItems = document.querySelectorAll('.big-list > p');


bigListItems.forEach(p => {
    p.addEventListener('click', e=>{
        if (!p.classList.contains('open')){
            if (open){
                open.classList.remove('p')
            }
            p.classList.add('open');
            open = p;
        } else {
            p.classList.remove('open');
            open = null;
        }
    })
});

document.querySelectorAll('.animated').forEach(el => {
    return el.dataset.autoAnimate = 1;
    
});