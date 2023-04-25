const { HtmlValidate, Reporter, formatterFactory } = require('html-validate');

const validator = new HtmlValidate({
    // Validate against standard (aka VNU) schema with some additional
    // accessibility checking
    extends: ["html-validate:standard", "html-validate:a11y"],
    rules: {
        // "Void-content" should be allowed
        // (aka the rule disallowing it should be disabled)
        "void-content": 0
    }
});

module.exports = async function validateHTML({results}){
    const files = results.filter(r => r.outputPath.match(/\.html$/gi));
    console.log(`Validating ${files.length} HTML files...`);
    const allReports = files.map(file => {
        return validator.validateFile(file.outputPath);
    });
    const report = Reporter.merge(allReports);
    if (!report.valid){
        const formatter = formatterFactory("stylish");
        console.error(formatter(report.results));
        throw new Error('validation error');
    }
    console.log('✅ All files valid')
}