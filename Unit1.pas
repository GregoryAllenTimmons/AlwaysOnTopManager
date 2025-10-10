unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes, System.Generics.Collections,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls;

type
  TWindowInfo = record
    Handle: HWND;
    Title: string;
    IsTopMost: Boolean;
  end;

  TForm1 = class(TForm)
    ListBoxWindows: TListBox;
    SpeedToggleTop: TSpeedButton;
    ButtonRefresh: TButton;
    StatusBar1: TStatusBar;
    ScrollBox1: TScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure ButtonRefreshClick(Sender: TObject);
    procedure ListBoxWindowsClick(Sender: TObject);
    procedure SpeedToggleTopClick(Sender: TObject);
  private
    WindowList: TList<TWindowInfo>;
    procedure RefreshWindowList;
    procedure UpdateButtonState;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function EnumWindowsProc(hWnd: HWND; lParam: LPARAM): BOOL; stdcall;
var
  Len: Integer;
  Title: array[0..255] of Char;
  Style: LongInt;
  Info: TWindowInfo;
begin
  Result := True; // continue enumeration

  if not IsWindowVisible(hWnd) then
    Exit;

  Len := GetWindowText(hWnd, Title, Length(Title));
  if Len = 0 then
    Exit;

  Style := GetWindowLong(hWnd, GWL_EXSTYLE);
  Info.Handle := hWnd;
  Info.Title := Title;
  Info.IsTopMost := (Style and WS_EX_TOPMOST) <> 0;

  TList<TWindowInfo>(Pointer(lParam)^).Add(Info);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption := 'Always On Top Manager';
  WindowList := TList<TWindowInfo>.Create;

  SpeedToggleTop.Caption := 'Always On Top';
  SpeedToggleTop.AllowAllUp := True;
  SpeedToggleTop.GroupIndex := 1;

  ButtonRefresh.Caption := 'Refresh List';

  StatusBar1.Panels[0].Text := 'Ready';
  RefreshWindowList;
end;

procedure TForm1.RefreshWindowList;
var
  i: Integer;
  mark: string;
  MaxWidth, TextWidth: Integer;
begin
  WindowList.Clear;
  EnumWindows(@EnumWindowsProc, LPARAM(@WindowList));

  ListBoxWindows.Items.BeginUpdate;
  try
    ListBoxWindows.Items.Clear;
    MaxWidth := 0;

    for i := 0 to WindowList.Count - 1 do
    begin
      if WindowList[i].IsTopMost then
        mark := '★ '
      else
        mark := '   ';

      ListBoxWindows.Items.Add(mark + WindowList[i].Title);

      // measure the visual width of the string in pixels
      TextWidth := ListBoxWindows.Canvas.TextWidth(mark + WindowList[i].Title);
      if TextWidth > MaxWidth then
        MaxWidth := TextWidth;
    end;

    // add a small margin so the longest line isn't cut off
    ListBoxWindows.ScrollWidth := (MaxWidth * 3);

  finally
    ListBoxWindows.Items.EndUpdate;
  end;

  StatusBar1.Panels[0].Text := Format('%d visible windows', [WindowList.Count]);
  SpeedToggleTop.Down := False;
end;


procedure TForm1.UpdateButtonState;
var
  idx: Integer;
begin
  idx := ListBoxWindows.ItemIndex;
  if (idx < 0) or (idx >= WindowList.Count) then
    Exit;

  SpeedToggleTop.Down := WindowList[idx].IsTopMost;
  StatusBar1.Panels[0].Text := Format('HWND: %d  |  %s',
    [WindowList[idx].Handle, WindowList[idx].Title]);
end;

procedure TForm1.ButtonRefreshClick(Sender: TObject);
begin
  RefreshWindowList;
end;

procedure TForm1.ListBoxWindowsClick(Sender: TObject);
begin
  UpdateButtonState;
end;

procedure TForm1.SpeedToggleTopClick(Sender: TObject);
var
  idx: Integer;
  Info: TWindowInfo;
  NewState: Boolean;
begin
  idx := ListBoxWindows.ItemIndex;
  if (idx < 0) or (idx >= WindowList.Count) then
    Exit;

  Info := WindowList[idx];
  NewState := not Info.IsTopMost;

  if NewState then
    SetWindowPos(Info.Handle, HWND_TOPMOST, 0, 0, 0, 0,
      SWP_NOMOVE or SWP_NOSIZE)
  else
    SetWindowPos(Info.Handle, HWND_NOTOPMOST, 0, 0, 0, 0,
      SWP_NOMOVE or SWP_NOSIZE);

  RefreshWindowList;
end;

end.

