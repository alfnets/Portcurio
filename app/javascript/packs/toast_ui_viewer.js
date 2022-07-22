import Viewer from '@toast-ui/editor/dist/toastui-editor-viewer';
const org_markdown = document.getElementById('org_markdown').value

const viewer = new Viewer({
  el: document.querySelector('#toast_viewer'),
  height: '600px',
  initialValue: org_markdown
});

require("packs/toast_ui_viewer")