unit mainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, Menus,
  SynEdit, SynHighlighterPHP;

type

  { TForm1 }

  TForm1 = class(TForm)
    editWindow: TSynEdit;
    lstImages: TImageList;
    mnmnuEditor: TMainMenu;
    FileMenu: TMenuItem;
    divider: TMenuItem;
    divider2: TMenuItem;
    mnuToolbar: TMenuItem;
    mnuHints: TMenuItem;
    mnuLine: TMenuItem;
    mnuPaste: TMenuItem;
    mnuCopy: TMenuItem;
    mnuCut: TMenuItem;
    mnuUndo: TMenuItem;
    mnuExit: TMenuItem;
    mnuSaveAs: TMenuItem;
    mnuSave: TMenuItem;
    mnuOpen: TMenuItem;
    mnuNew: TMenuItem;
    EditMenu: TMenuItem;
    MenuItem4: TMenuItem;
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    sbarStatus: TStatusBar;
    SynPHPSyn1: TSynPHPSyn;
    tbarMain: TToolBar;
    tbtnNew: TToolButton;
    tbtnOpen: TToolButton;
    tbtnSave: TToolButton;
    tbarDivider1: TToolButton;
    tbtnExit: TToolButton;
    tbarDivider2: TToolButton;
    tbtnUndo: TToolButton;
    tbtnCut: TToolButton;
    tbtnCopy: TToolButton;
    tbtnPaste: TToolButton;
    procedure mnuCopyClick(Sender: TObject);
    procedure mnuCutClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuHintsClick(Sender: TObject);
    procedure mnuLineClick(Sender: TObject);
    procedure mnuNewClick(Sender: TObject);
    procedure mnuOpenClick(Sender: TObject);
    procedure mnuPasteClick(Sender: TObject);
    procedure mnuSaveAsClick(Sender: TObject);
    procedure mnuSaveClick(Sender: TObject);
    procedure mnuToolbarClick(Sender: TObject);
    procedure mnuUndoClick(Sender: TObject);
  private

  public
    sFileName: string;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.mnuNewClick(Sender: TObject);
begin
  sFileName := '';
  editWindow.Lines.Clear;
  sbarStatus.SimpleText := '';
end;

procedure TForm1.mnuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.mnuHintsClick(Sender: TObject);
begin
  mnuHints.Checked := not mnuHints.Checked;
  tbarMain.ShowHint := mnuHints.Checked;
end;

procedure TForm1.mnuLineClick(Sender: TObject);
begin
  mnuLine.Checked := not mnuLine.Checked;
  editWindow.Gutter.Visible := mnuLine.Checked;
end;

procedure TForm1.mnuCutClick(Sender: TObject);
begin
  editWindow.CutToClipboard;
end;

procedure TForm1.mnuCopyClick(Sender: TObject);
begin
  editWindow.CopyToClipboard;
end;

procedure TForm1.mnuOpenClick(Sender: TObject);
begin
  if dlgOpen.Execute then
  begin
    sFileName := dlgOpen.FileName;
    editWindow.Lines.LoadFromFile(sFileName);
    sbarStatus.SimpleText := ExtractFileName(sFileName);
  end;
end;

procedure TForm1.mnuPasteClick(Sender: TObject);
begin
  editWindow.PasteFromClipboard;
end;

procedure TForm1.mnuSaveAsClick(Sender: TObject);
begin
  if dlgSave.Execute then
  begin
    sFileName := dlgSave.FileName;
    editWindow.Lines.SaveToFile(sFileName);
    sbarStatus.SimpleText := ExtractFileName(sFileName);
  end;
end;

procedure TForm1.mnuSaveClick(Sender: TObject);
begin
  if Length(sFileName) = 0 then
    mnuSaveAsClick(Sender)
  else
    editWindow.Lines.SaveToFile(sFileName);
end;

procedure TForm1.mnuToolbarClick(Sender: TObject);
begin
  mnuToolbar.Checked := not mnuToolbar.Checked;
  tbarMain.Visible := mnuToolbar.Checked;
end;

procedure TForm1.mnuUndoClick(Sender: TObject);
begin
  editWindow.Undo;
end;

end.

