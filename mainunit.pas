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
    dividerY: TMenuItem;
    mnuCommentLine: TMenuItem;
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
    procedure editWindowKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FindDialog1Find(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnuCommentLineClick(Sender: TObject);
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
  sbarStatus.Panels[1].Text := 'untitled file';
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
  //autocomplete.. maybe add a timer
  //editWindow.CommandProcessor(SynCompletion1.ExecCommandID, '', nil);
end;

procedure TForm1.editWindowKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  sbarStatus.Panels[0].Text :=
    'Line ' + IntToStr(editWindow.CaretY) + ', Column ' + IntToStr(editWindow.CaretX);
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
  XMLPropStorage1.FileName := GetUserDir + 'PHPeasySettings.xml';
end;

procedure TForm1.mnuCommentLineClick(Sender: TObject);
var
  selectedLine: integer;
begin
  if (editWindow.BlockBegin.y <> editWindow.BlockEnd.y) then
  begin
    for selectedLine := editWindow.BlockBegin.y to editWindow.BlockEnd.y do
    begin
      editWindow.Lines[selectedLine - 1] := '//' + editWindow.Lines[selectedLine];
    end;
  end
  else
  begin
    editWindow.CaretX := 0;
    editWindow.InsertTextAtCaret('//');
  end;
end;

procedure TForm1.mnuOpenClick(Sender: TObject);
begin
  if isSaved = False then
    savePrompt;
  if dlgOpen.Execute then
  begin
    sFileName := dlgOpen.FileName;
    editWindow.Lines.LoadFromFile(sFileName);
    sbarStatus.Panels[1].Text := ExtractFileName(sFileName);
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
    sbarStatus.Panels[1].Text := ExtractFileName(sFileName);
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
  Add('addcslashes()');
  Add('addslashes()');
  Add('array_keys()');
  Add('array_key_exists()');
  Add('array_merge()');
  Add('array_pop()');
  Add('array_shift()');
  Add('array_values()');
  Add('bin2hex()');
  Add('bool');
  Add('ceil()');
  Add('chop()');
  Add('chunk_split()');
  Add('convert_cyr_str()');
  Add('convert_uudecode()');
  Add('convert_uuencode()');
  Add('count()');
  Add('count_chars()');
  Add('crc32()');
  Add('crypt()');
  Add('date()');
  Add('die()');
  Add('dirname()');
  Add('defined()');
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
  Add('explode()');
  Add('extends');
  Add('false');
  Add('file_get_contents()');
  Add('file_put_contents()');
  Add('final');
  Add('finally');
  Add('float');
  Add('for');
  Add('foreach');
  Add('fprintf()');
  Add('function');
  Add('function_exists()');
  Add('getenv()');
  Add('get_html_translation_table()');
  Add('getrandmax()');
  Add('gettype()');
  Add('global');
  Add('goto');
  Add('header()');
  Add('hebrev()');
  Add('hebrevc()');
  Add('hex2bin()');
  Add('html_entity_decode()');
  Add('htmlentities()');
  Add('htmlspecialchars_decode');
  Add('htmlspecialchars()');
  Add('implements');
  Add('implode()');
  Add('include');
  Add('include_once');
  Add('ini_set()');
  Add('instanceof');
  Add('insteadof');
  Add('interface');
  Add('in_array()');
  Add('is_array()');
  Add('is_dir()');
  Add('is_null()');
  Add('is_numeric()');
  Add('is_object()');
  Add('isset()');
  Add('iterable');
  Add('json_encode()');
  Add('json_decode()');
  Add('list()');
  Add('ltrim()');
  Add('mail');
  Add('method_exists()');
  Add('mkdir');
  Add('namespace');
  Add('new');
  Add('null');
  Add('object');
  Add('phpinfo');
  Add('preg_match()');
  Add('print');
  Add('print_r()');
  Add('private');
  Add('protected');
  Add('public');
  Add('rand()');
  Add('require');
  Add('require_once');
  Add('return');
  Add('rtrim()');
  Add('sprintf()');
  Add('static');
  Add('string');
  Add('strlen()');
  Add('str_pad()');
  Add('strpos()');
  Add('str_repeat()');
  Add('str_replace()');
  Add('strrev()');
  Add('strtolower()');
  Add('strtoupper()');
  Add('substr()');
  Add('substr_count()');
  Add('switch');
  Add('throw');
  Add('time()');
  Add('trait');
  Add('trim()');
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
