import Editor from '@toast-ui/editor';
const org_markdown = document.getElementById('org_markdown').value

const options = {
  usageStatistics: false
};
const editor = new Editor({
  el: document.querySelector('#toast_editor'),
  height: '500px',
  initialValue: org_markdown,
  initialEditType: 'markdown',
  previewStyle: 'vertical',
  options
});

editor.getMarkdown();

$(document).on('turbolinks:load', 
  $('#links_save').on('click', () => {
    const markdown = editor.getMarkdown().replace(/&/g, "&amp;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;")
      .replace(/`/g, "&#096;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;");
      // .replace(/\n/g, "<br>");
    $('#links_save').after(`<input type="hidden" name="markdown" value='${markdown}'>`);
  })
);

require("packs/toast_ui_editor")