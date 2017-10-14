unit FormFileEdit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynEdit, Forms, Controls, Graphics, Dialogs,
  ComCtrls;

type

  { TfrmFileEdit }

  TfrmFileEdit = class(TForm)
    Editor: TSynEdit;
    StatusBar: TStatusBar;
    procedure EditorChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FLineNumbers: Integer;
    FFileName: string;

    procedure UpdateStatusBar;
  public
    constructor Create(TheOwner: TComponent; sFileName: string); overload;

    function GetFileName: string;
    procedure SaveToFile(const sFileName: string);
  end;

var
  frmFileEdit: TfrmFileEdit;

implementation

{$R *.lfm}

{ TfrmFileEdit }

procedure TfrmFileEdit.EditorChange(Sender: TObject);
begin
  UpdateStatusBar;
end;

procedure TfrmFileEdit.FormCreate(Sender: TObject);
begin
  if FFileName <> '' then Editor.Lines.LoadFromFile(FFileName);
  UpdateStatusBar;
end;

constructor TfrmFileEdit.Create(TheOwner: TComponent; sFileName: string);
begin
  inherited Create(TheOwner);

  FFileName := sFileName;
end;

function TfrmFileEdit.GetFileName: string;
begin
  Result := FFileName;
end;

procedure TfrmFileEdit.SaveToFile(const sFileName: string);
begin
  { TODO -oDavid -cAplikace : Dodělat dotaz na existenci souboru }
  if sFileName = '' then Editor.Lines.SaveToFile(FFileName)
  else begin
    Editor.Lines.SaveToFile(sFileName);
    FFileName := sFileName;
  end;
end;

procedure TfrmFileEdit.UpdateStatusBar;
begin
  if FLineNumbers <> Editor.Lines.Count then FLineNumbers := Editor.Lines.Count;
  StatusBar.Panels[0].Text := IntToStr(FLineNumbers) + ':';
end;

end.

