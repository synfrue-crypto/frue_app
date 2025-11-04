
// Minimal helper to trigger a download in the browser
function dart_webDownload(bytes, name) {
  const blob = new Blob([new Uint8Array(bytes)], {type: 'text/plain'});
  const url = URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = name || 'download.txt';
  document.body.appendChild(a);
  a.click();
  a.remove();
  URL.revokeObjectURL(url);
}
