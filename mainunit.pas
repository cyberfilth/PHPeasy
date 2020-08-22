unit mainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, ComCtrls, Menus,
  SynEdit, SynHighlighterPHP, SynCompletion, lcltype, XMLPropStorage;

type

  { TForm1 }

  TForm1 = class(TForm)
    editWindow: TSynEdit;
    FindDialog1: TFindDialog;
    lstImages: TImageList;
    dividerX: TMenuItem;
    themeAcademy: TMenuItem;
    themePeaGreen: TMenuItem;
    viewDivider1: TMenuItem;
    mnuThemes: TMenuItem;
    mnuReplace: TMenuItem;
    mnuFind: TMenuItem;
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
    mnuView: TMenuItem;
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    ReplaceDialog1: TReplaceDialog;
    sbarStatus: TStatusBar;
    SynCompletion1: TSynCompletion;
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
    tbtnDivider3: TToolButton;
    tbtnSearch: TToolButton;
    tbtnReplace: TToolButton;
    XMLPropStorage1: TXMLPropStorage;
    procedure editWindowChange(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnuCopyClick(Sender: TObject);
    procedure mnuCutClick(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure mnuFindClick(Sender: TObject);
    procedure mnuHintsClick(Sender: TObject);
    procedure mnuLineClick(Sender: TObject);
    procedure mnuNewClick(Sender: TObject);
    procedure mnuOpenClick(Sender: TObject);
    procedure mnuPasteClick(Sender: TObject);
    procedure mnuReplaceClick(Sender: TObject);
    procedure mnuSaveAsClick(Sender: TObject);
    procedure mnuSaveClick(Sender: TObject);
    procedure mnuToolbarClick(Sender: TObject);
    procedure mnuUndoClick(Sender: TObject);
    procedure ReplaceDialog1Find(Sender: TObject);
    procedure ReplaceDialog1Replace(Sender: TObject);
    procedure savePrompt;
    procedure setSelLength(var textComponent: TSynEdit; newValue: integer);
    procedure SynCompletion1Execute(Sender: TObject);
    procedure themeAcademyClick(Sender: TObject);
    procedure themePeaGreenClick(Sender: TObject);
  private

  public
    sFileName: string;
    isSaved: boolean;
    fPos: integer;
    found: boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.mnuNewClick(Sender: TObject);
begin
  if isSaved = False then
    savePrompt;
  sFileName := '';
  editWindow.Lines.Clear;
  sbarStatus.SimpleText := '';
  isSaved := True;
  Form1.Caption := 'PHPeasy';
end;

procedure TForm1.mnuExitClick(Sender: TObject);
begin
  if isSaved = False then
    savePrompt;
  Close;
end;

procedure TForm1.mnuFindClick(Sender: TObject);
begin
  FPos := 0;
  findDialog1.Execute;
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

procedure TForm1.editWindowChange(Sender: TObject);
begin
  if (isSaved = True) then
  begin
    isSaved := False;
    Form1.Caption := 'PHPeasy *';
  end;
end;

procedure TForm1.FindDialog1Find(Sender: TObject);
var
  FindS: string;
  IPos, FLen, SLen, Res: integer;
begin
  {FPos is global}
  Found := False;
  FLen := Length(findDialog1.FindText);
  SLen := Length(editWindow.Text);
  FindS := findDialog1.FindText;

  if frMatchcase in findDialog1.Options then
    IPos := Pos(FindS, Copy(editWindow.Text, FPos + 1, SLen - FPos))
  else
    IPos := Pos(AnsiUpperCase(FindS),
      AnsiUpperCase(Copy(editWindow.Text, FPos + 1, SLen - FPos)));

  if IPos > 0 then
  begin
    FPos := FPos + IPos;
    //   Hoved.BringToFront;       {Edit control must have focus in }
    editWindow.SetFocus;
    Self.ActiveControl := editWindow;
    editWindow.SelStart := FPos;  // {Select the string found by POS
    setSelLength(editWindow, FLen);     //editWindow.SelLength := FLen;
    Found := True;
    FPos := FPos + FLen - 1;   //move just past end of found item

  end
  else
  begin
    Res := Application.MessageBox('Text was not found!', 'Find',
      mb_OK + mb_ICONWARNING);
    FPos := 0;     //user might cancel dialog, so setting here is not enough
  end;             //   - also do it before exec of dialog.
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
  isSaved := True;
  XMLPropStorage1.FileName := GetUserDir+'PHPeasySettings.xml';
end;

procedure TForm1.mnuOpenClick(Sender: TObject);
begin
  if isSaved = False then
    savePrompt;
  if dlgOpen.Execute then
  begin
    sFileName := dlgOpen.FileName;
    editWindow.Lines.LoadFromFile(sFileName);
    sbarStatus.SimpleText := ExtractFileName(sFileName);
    isSaved := True;
    Form1.Caption := 'PHPeasy';
  end;
end;

procedure TForm1.mnuPasteClick(Sender: TObject);
begin
  editWindow.PasteFromClipboard;
end;

procedure TForm1.mnuReplaceClick(Sender: TObject);
begin
  FPos := 0;
  replaceDialog1.Execute;
end;

procedure TForm1.mnuSaveAsClick(Sender: TObject);
begin
  if dlgSave.Execute then
  begin
    sFileName := dlgSave.FileName;
    editWindow.Lines.SaveToFile(sFileName);
    sbarStatus.SimpleText := ExtractFileName(sFileName);
    isSaved := True;
    Form1.Caption := 'PHPeasy';
  end;
end;

procedure TForm1.mnuSaveClick(Sender: TObject);
begin
  if Length(sFileName) = 0 then
    mnuSaveAsClick(Sender)
  else
  begin
    editWindow.Lines.SaveToFile(sFileName);
    isSaved := True;
    Form1.Caption := 'PHPeasy';
  end;
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

procedure TForm1.ReplaceDialog1Find(Sender: TObject);
var
  FindS: string;
  IPos, FLen, SLen: integer;
  Res: integer;
begin
  {FPos is global}
  Found := False;
  FLen := Length(ReplaceDialog1.FindText);
  SLen := Length(editWindow.Text);
  FindS := ReplaceDialog1.FindText;

  if frMatchcase in ReplaceDialog1.Options then
    IPos := Pos(FindS, Copy(editWindow.Text, FPos + 1, SLen - FPos))
  else
    IPos := Pos(AnsiUpperCase(FindS), AnsiUpperCase(
      Copy(editWindow.Text, FPos + 1, SLen - FPos)));

  if IPos > 0 then
  begin
    FPos := FPos + IPos;
    // Edit control must have focus
    editWindow.SetFocus;
    Self.ActiveControl := editWindow;
    editWindow.SelStart := FPos;  // Select the string found by POS
    setSelLength(editWindow, FLen);     //editWindow.SelLength := FLen;
    Found := True;
    FPos := FPos + FLen - 1;   //move just past end of found item
  end
  else
  begin
    if not (ReplaceDialog1.Options * [frReplaceAll] = [frReplaceAll]) then
      Res := Application.MessageBox('Text was not found!', 'Replace',
        mb_OK + mb_ICONWARNING);
    FPos := 0;     // user might cancel dialog, so setting here is not enough
  end;             //   - also do it before exec of dialog.

end;

procedure TForm1.ReplaceDialog1Replace(Sender: TObject);
var
  Res, replaceCount: integer;
  countInfo: string;
begin
  if Found = False then  //If no search for string took place
  begin
    ReplaceDialog1Find(Sender); // Search for string, replace if found
    if Length(editWindow.SelText) > 0 then
      editWindow.SelText := ReplaceDialog1.ReplaceText;
  end
  else                          //If search ran, replace string
  begin
    if Length(editWindow.SelText) > 0 then
      editWindow.SelText := ReplaceDialog1.ReplaceText;
  end;
  Found := False;
  setSelLength(editWindow, 0);    //editWindow.SelLength := 0;
  if (ReplaceDialog1.Options * [frReplaceAll] = [frReplaceAll]) then
  begin
    replaceCount := 0;
    repeat
      ReplaceDialog1Find(Sender); {Search for string, replace if found}
      if Length(editWindow.SelText) > 0 then
      begin
        editWindow.SelText := ReplaceDialog1.ReplaceText;
        replaceCount := replaceCount + 1;
      end;
    until Found = False;
    if replaceCount > 0 then
      replaceCount := replaceCount + 1;   //the first 1, then loop for rest
    countInfo := IntToStr(replaceCount) + '  replacements made.';
    Res := Application.MessageBox(PChar(countInfo), 'Replace', mb_OK +
      mb_ICONINFORMATION);
  end;
end;

procedure TForm1.savePrompt; // If file has been amended but not saved
begin
  if MessageDlg('Save changes?', 'Do you want to save this file?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    mnuSaveClick(nil);
end;

procedure TForm1.setSelLength(var textComponent: TSynEdit; newValue: integer);
begin
  textComponent.SelEnd := textComponent.SelStart + newValue;
end;

procedure TForm1.SynCompletion1Execute(Sender: TObject);

  procedure Add(s: string);
  begin
    if pos(lowercase(SynCompletion1.CurrentString), lowercase(s)) = 1 then
      SynCompletion1.ItemList.Add(s);
  end;

begin
  SynCompletion1.ItemList.Clear;
  Add('bool');
  Add('echo');
  Add('else');
  Add('elseif');
  Add('empty()');
  Add('enddeclare');
  Add('endfor');
  Add('endforeach');
  Add('endif');
  Add('endswitch');
  Add('endwhile');
  Add('eval()');
  Add('exit()');
  Add('extends');
  Add('false');
  Add('final');
  Add('finally');
  Add('float');
  Add('for');
  Add('foreach');
  Add('function');
  Add('global');
  Add('goto');
  Add('implements');
  Add('include');
  Add('include_once');
  Add('instanceof');
  Add('insteadof');
  Add('interface');
  Add('isset()');
  Add('iterable');
  Add('list()');
  Add('namespace');
  Add('new');
  Add('null');
  Add('object');
  Add('print');
  Add('private');
  Add('protected');
  Add('public');
  Add('require');
  Add('require_once');
  Add('return');
  Add('static');
  Add('string');
  Add('switch');
  Add('throw');
  Add('trait');
  Add('true');
  Add('unset()');
  Add('void');
  Add('while');
  Add('yield');
  Add('yield_from');
end;

(* Academy dark theme *)
procedure TForm1.themeAcademyClick(Sender: TObject);
begin
  editWindow.Color := $2F1E20;
  SynPHPSyn1.CommentAttri.Foreground := $7B7473;
  SynPHPSyn1.IdentifierAttri.Foreground := $7656D1;
  SynPHPSyn1.KeyAttri.Foreground := $F3C2AA;
  SynPHPSyn1.NumberAttri.Foreground := $7656D1;
  SynPHPSyn1.StringAttri.Foreground := $83E0FF;
  SynPHPSyn1.SymbolAttri.Foreground := $FAFAFA;
  SynPHPSyn1.VariableAttri.Foreground := $6B7DE7;
end;

(* PeaGreen light theme *)
procedure TForm1.themePeaGreenClick(Sender: TObject);
begin
  editWindow.Color := $FAFAFA;
  SynPHPSyn1.CommentAttri.Foreground := $5B805C;
  SynPHPSyn1.IdentifierAttri.Foreground := $A2502A;
  SynPHPSyn1.KeyAttri.Foreground := $722674;
  SynPHPSyn1.NumberAttri.Foreground := $16526E;
  SynPHPSyn1.StringAttri.Foreground := $346B35;
  SynPHPSyn1.SymbolAttri.Foreground := $383332;
  SynPHPSyn1.VariableAttri.Foreground := $313998;
end;

end.
