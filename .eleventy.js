const { HtmlValidate, Reporter, formatterFactory } = require('html-validate');

async function validateHTML({results}){
    const validator = new HtmlValidate({
        // Validate against standard (aka VNU) schema
        extends: ["html-validate:standard", "html-validate:a11y"],
        rules: {
            "void-content": 0
        }
    });
    const files = results.filter(r => r.outputPath.match(/\.html$/gi));
    const allReports = files.map(file => {
        return validator.validateFile(file.outputPath);
    });
    const report = Reporter.merge(allReports);
    if (!report.valid){
        const formatter = formatterFactory("stylish");
        console.error(formatter(report.results));
        throw new Error('validation error');
    }
}




/**
 * Function to validate HTML using VNU inspired
 * by https://github.com/matt-auckland/eleventy-plugin-html-validate
 * @param results
 */



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
    eleventyConfig.addTransform('wbr', function(content){
        if (!(/<a[^>]+>[^>]+\//gi.test(content))){
            return content;
        };
        let newContent = content.replace(/(<a[^>]+>)([^<]+)(<)/gi, function(match, g1, g2, g3){
            let fixed = g2.replace(/([^\/]\/)/gi,'$1<wbr/>');
            return `${g1}${fixed}${g3}`;
        });
        return newContent;
    });
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