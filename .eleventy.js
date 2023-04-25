const validateHTML = require('./validate.js');

function softBreakLinks(content) {
    if (!(/<a[^>]+>[^>]+\//gi.test(content))) {
        return content;
    };
    let newContent = content.replace(/(<a[^>]+>)([^<]+)(<)/gi, function (match, g1, g2, g3) {
        let fixed = g2.replace(/([^\/]\/)/gi, '$1<wbr/>');
        return `${g1}${fixed}${g3}`;
    });
    return newContent;
};

module.exports = function(eleventyConfig) {
    const markdownIt = require('markdown-it');
    const markdownItOptions = {
        html: true,
        linkify: true
    };
    const md = markdownIt(markdownItOptions);
    const shortcodes = { 
        activity: function(content){
            const rendered = md.render(content);
            return `<details class="activity"><summary>Activity</summary>${rendered}</details>`;
        },
        bibliography: function(content){
            const rendered = md.render(content);
            return `<div class="bibliography">${rendered}</div>`;
        }
    };
    eleventyConfig.addFilter("markdownify", string => {
        return md.render(string)
    });
    eleventyConfig.setLibrary('md', md);
    eleventyConfig.addTransform('wbr', softBreakLinks);

    for (const code in shortcodes){
        eleventyConfig.addPairedShortcode(code, shortcodes[code]);
    }
    eleventyConfig.addPassthroughCopy('assets');
    eleventyConfig.setUseGitIgnore(false);
    eleventyConfig.on('eleventy.after', validateHTML);
    return {
        dir: {
            input: ".",
            output: "_site",
            layouts: "layouts"
        },
        passthroughFileCopy: true,
        pathPrefix: '/dh-guelph-2023/'
    }
}