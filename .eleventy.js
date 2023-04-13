module.exports = function(eleventyConfig) {
    const markdownIt = require('markdown-it');
    const markdownItOptions = {
        html: true,
        linkify: true
    };
    const md = markdownIt(markdownItOptions)
    eleventyConfig.addFilter("markdownify", string => {
        return md.render(string)
    })
    eleventyConfig.setLibrary('md', md);
    eleventyConfig.addTransform('wbr', function(content){
        let newContent = content.replace(/(<a[^>]+>)([^<]+)(<)/gi, function(match, g1, g2, g3){
            console.log(match);
            let fixed = g2.replace(/([^\/]\/)/gi,'$1<wbr/>');
            return `${g1}${fixed}${g3}`;
        });
        return newContent;
    });
    
    eleventyConfig.addPassthroughCopy('assets');
    eleventyConfig.setUseGitIgnore(false);
    
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