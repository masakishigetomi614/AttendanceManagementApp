const { app, BrowserWindow, Tray, Menu } = require('electron');
let tray = null;

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      nodeIntegration: true,
    },
  });

  mainWindow.loadFile('index.html');

  // Tray icon を作成
  tray = new Tray('path-to-your-icon.png'); // アイコンファイルのパスを指定
  const contextMenu = Menu.buildFromTemplate([
    {
      label: 'Show', click: () => {
        mainWindow.show(); // ウィンドウを表示
      },
    },
    {
      label: 'Exit', click: () => {
        app.quit(); // アプリケーションを終了
      },
    },
  ]);
  tray.setContextMenu(contextMenu);
  tray.setToolTip('Attendance Tracker');
  
  // ウィンドウが閉じられた際に非表示にする
  mainWindow.on('close', (event) => {
    event.preventDefault();
    mainWindow.hide();
  });
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});
