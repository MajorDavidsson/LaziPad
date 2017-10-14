unit FormMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, ComCtrls, ActnList;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    actExit: TAction;
    actFullscreen: TAction;
    actAbout: TAction;
    actSaveFileAs: TAction;
    actSaveFile: TAction;
    actOpenFile: TAction;
    actNewFile: TAction;
    ActionList: TActionList;
    MainMenu: TMainMenu;
    itmFile: TMenuItem;
    itmNewFile: TMenuItem;
    itmOpenFile: TMenuItem;
    itmSaveFile: TMenuItem;
    itmSaveFileAs: TMenuItem;
    itmFileSeparator: TMenuItem;
    itmExit: TMenuItem;
    itmHelp: TMenuItem;
    itmAbout: TMenuItem;
    itmView: TMenuItem;
    itmFullscreen: TMenuItem;
    OpenDialog: TOpenDialog;
    PageControl: TPageControl;
    SaveDialog: TSaveDialog;
    procedure actExitExecute(Sender: TObject);
    procedure actFullscreenExecute(Sender: TObject);
    procedure actNewFileExecute(Sender: TObject);
    procedure actOpenFileExecute(Sender: TObject);
    procedure actSaveFileAsExecute(Sender: TObject);
    procedure actSaveFileExecute(Sender: TObject);
  private
    procedure CreateTab(const sFileName: string = '');
    function ExistTab(const sFileName: string): TTabSheet;
    procedure SaveToFile(const sFileName: string = '');
    procedure UpdateTabCaption(const sFileName: string);
  public

  end;

var
  frmMain: TfrmMain;

implementation

uses
  FormFileEdit;

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.actNewFileExecute(Sender: TObject);
begin
  CreateTab;
end;

procedure TfrmMain.actOpenFileExecute(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    CreateTab(OpenDialog.FileName);
  end;
end;

procedure TfrmMain.actSaveFileAsExecute(Sender: TObject);
begin
  if SaveDialog.Execute then
  begin
    SaveToFile(SaveDialog.FileName);
  end;
end;

procedure TfrmMain.actSaveFileExecute(Sender: TObject);
begin
  SaveToFile;
end;

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.actFullscreenExecute(Sender: TObject);
begin
  actFullscreen.Checked := not actFullscreen.Checked;
  if actFullscreen.Checked then Self.WindowState := wsMaximized
  else Self.WindowState := wsNormal;
end;

procedure TfrmMain.CreateTab(const sFileName: string = '');
var
  tab: TTabSheet;
  frm: TfrmFileEdit;
begin
  PageControl.ActivePage := ExistTab(sFileName);

  if PageControl.ActivePage <> nil then Exit;

  tab := PageControl.AddTabSheet;
  if sFileName = '' then tab.Caption := 'Nový.txt'
  else tab.Caption := ExtractFileName(sFileName);
  PageControl.ActivePage := tab;
  frm := TfrmFileEdit.Create(tab, sFileName);
  tab.InsertControl(frm);
  frm.Visible := True;
  frm.Left := tab.Left;
  frm.Top := tab.Top;
  frm.Align := alclient;
end;

function TfrmMain.ExistTab(const sFileName: string): TTabSheet;
var
  i: Integer;
  frm: TfrmFileEdit;
begin
  Result := nil;

  if sFileName = '' then Exit;

  for i := 0 to PageControl.PageCount-1 do
  begin
    frm := TfrmFileEdit(PageControl.Pages[i].Controls[0]);
    if frm.GetFileName = sFileName then
    begin
      Result := PageControl.Pages[i];
      Break;
    end;
  end;
end;

procedure TfrmMain.SaveToFile(const sFileName: string = '');
var
  frm: TfrmFileEdit;
begin
  frm := TfrmFileEdit(PageControl.ActivePage.Controls[0]);
  frm.SaveToFile(sFileName);
  UpdateTabCaption(sFileName);
end;

procedure TfrmMain.UpdateTabCaption(const sFileName: string);
begin
  if sFileName = '' then Exit;

  PageControl.ActivePage.Caption := ExtractFileName(sFileName);
end;

end.

