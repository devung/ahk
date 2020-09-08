#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force
#InstallKeybdHook
GroupAdd, vsCode, ahk_exe Code.exe

vWinX := 760
vWinY := 0
vLable := ""

fnLayer := false
profile := 1 ;1 = qwerty, 0 = colemak 

$Capslock::
  fnLayer := !fnLayer
  vLable := fnLayer = true
    ? "NavMode"
    : profile = 1 ? "Qwerty" : "Colemak"
  SplashTextOn, 100, 20, %vLable%
  WinMove, %vLable%, , %vWinX%, %vWinY%
Return

$RControl::
  profile := !profile
  vLable := fnLayer = true
    ? "NavMode"
    : profile = 1 ? "Qwerty" : "Colemak"
  SplashTextOn, 100, 20, %vLable%
  WinMove, %vLable%, , %vWinX%, %vWinY%
return

Up::Return
Down::Return
Left::Return
Right::Return

#If fnLayer=true
  a::Return
  b::Return
  f::Return
  g::Return
  o::Return
  t::Return
  u::Return
  z::Return
  [::Return
  ]::Return
  '::Return
  ,::Return
  /::Return

  $i::Up
  $k::Down
  $j::Left
  $l::Right
  $h::Home
  $`;::End
  $y::PgUp
  $n::PgDn

  $m::
    Send, {CtrlDown}{Left}{CtrlUp} 
  Return ;Pervious word
  .::
    Send, {CtrlDown}{Right}{CtrlUp}
  Return ;Next word

  w::Send, {LWin Down}
  w up::Send, {LWin UP}

/*
  s::Send, {LShift Down}
  s up::Send, {LShift Up}
*/

  s::
    KeyWait, s			                                                        ;wait for s to be released
    KeyWait, s, D T0.2		                                                  ;wait for s to be pressed again within 0.2 second
    If ErrorLevel 			                                                    ;if timed-out ErrorLevel = 1 to indicate single press
      Return                                                                ;return on single press
    Else
      Send, {CtrlDown}{Left}{RShift Down}{Right}{CtrlUp}{RShift Up}      ;else double press; select the word on cursor
  Return

  s & i::
    Send, {ShiftDown}{Up}{ShiftUp}
  Return
  s & k::
    Send, {ShiftDown}{Down}{ShiftUp}
  Return
  s & j::
    Send, {ShiftDown}{Left}{ShiftUp}
  Return
  s & l::
    Send, {ShiftDown}{Right}{ShiftUp}
  Return

  s & w::
    Send, {CtrlDown}{Right}{Left}{Shift Down}{Right}{Shift Up}{CtrlUp}      ;else double press; select the word on cursor
  Return

  s & m::
    Send, {CtrlDown}{Shift Down}{Left}{Shift Up}{CtrlUp}
  Return
  
  s & .::
    Send, {CtrlDown}{Shift Down}{Right}{Shift Up}{CtrlUp}
  Return
  
  +.::
    Send, {CtrlDown}{Shift Down}{Right}{Shift Up}{CtrlUp}
  Return
  +m::
    Send, {CtrlDown}{Shift Down}{Left}{Shift Up}{CtrlUp}
  Return

  s & `;::                                                                  ;` is to escape the semi-colon ; as it is resevered for comments
    KeyWait, `;                                                             ;if timed-out ErrorLevel = 1 to indicate single press
    KeyWait, `;, D T0.2                                                     ;wait for ; to be pressed again within 0.2 second
    if ErrorLevel                                                           ;if timed-out ErrorLevel = 1 to indicate single press
      Send, {Shift Down}{End}{Shift Up}                                     ;single press; select from cursor to end of the time
    Else                                                                    
      Send, {Home}{Shift Down}{End}{Shift Up}                               ;double press; select whole line and cursor at end of line
  Return

  s & h::
    KeyWait, h
    KeyWait, h, D T0.2
    if ErrorLevel
      Send, {Shift Down}{Home}{Shift Up}                                    ;single press; select from cursor to begining of line.
    Else
      Send, {End}{Shift Down}{Home}{Shift Up}                               ;double press; select whole line. cursor at begining of line.
  Return
  
  s & a::Send, {CtrlDown}a{CtrlUp}                                          ;Select all
  Return

/*
    Save
*/
  ^s::Send, ^s
/*
    Delete
*/
  \::
    Send, {Delete}
  d::
    KeyWait, d                                                              ;wait for d to be released
    KeyWait, d, D T0.2		                                                  ;wait for d to be pressed again within 0.2 second
    If ErrorLevel                                                   ;if timed-out ErrorLevel = 1 to indicate single press
      Send, {Delete}                                                    ;return on single press
    Else{
      If (WinActive("ahk_group vsCode"))
        Send, ^+k                                                         ;else double press; delete whole line vs code shortcut
      else 
         Send, {Home}{Shift Down}{End}{Shift Up}{CtrlDown}x{CtrlUp}
    }
    KeyWait, d
  Return

  d & j::BackSpace
  d & l::Delete
  d & m::Send, ^{BackSpace}                                                 ;delete previous word
  d & .::Send, ^{Delete}                                                    ;delete next word
  d & h::Send, +{Home}{Delete}                                              ;delete from cursor to begining of line
  d & `;::Send, +{End}{Delete}                                              ;delete from cursor to end of line

/*
    Copy, Cut and Paste
*/
  c::
    KeyWait, c
    KeyWait, c, D T0.2
    If ErrorLevel
      Send, ^c                                                              ;copy
    Else
      Send, {Home}{Shift Down}{End}{Shift Up}{CtrlDown}c{CtrlUp}            ;copy whole line
  Return

  x::
    KeyWait, x
    KeyWait, x, D T0.2
    If ErrorLevel
      Send, ^x                                                              ;cut
    Else
      Send, {Home}{Shift Down}{End}{Shift Up}{CtrlDown}x{CtrlUp}            ;cut whole line
  Return

  *v::Send, ^v                                                              ;paste
  Return

/*
    Edit
*/
  e::
    Keywait, e
    KeyWait, e, D T0.2
    If ErrorLevel
      Send, ^{Enter}                                                        ;enter new line above
    Else
      Send, ^+{Enter}                                                       ;enter new line below
  Return

  e & i::
    Send, ^+{Enter}                                                         ;enter new line below
  Return
  e & k::
    Send, ^{Enter}                                                          ;enter new line above
  Return
  
  q::
    Send, ^z
  Return
 
  r::
    Send, ^y
  Return

/*
    Windows
*/
  #d::#d

Return

#If fnLayer=false and profile=0
  q::q
  w::w
  e::f
  r::p
  t::g
  y::j
  u::l
  i::u
  o::y
  p::;
  [::[
  ]::]
  \::\
  
  a::a
  s::r
  d::s
  f::t
  g::d
  h::h
  j::n
  k::e
  l::i
 `;::o
  '::'
  
  z::z
  x::x
  c::c
  v::v
  b::b
  n::k
  m::m
  ,::,
  .::.
  /::/
Return
