import Editor from '@toast-ui/editor';
const org_markdown = document.getElementById('org_markdown').value

const options = {
  usageStatistics: false
};
const editor = new Editor({
  el: document.querySelector('#toast_editor'),
  height: '500px',
  initialValue: org_markdown,
  initialEditType: 'wysiwyg',
  previewStyle: 'vertical',
  options
});

editor.getMarkdown();

$('#links_save').on('click', () => {
  $('#links_save').after(`<input type="hidden" name="markdown" value="${editor.getMarkdown()}">`);
});

require("packs/toast_ui_editor")