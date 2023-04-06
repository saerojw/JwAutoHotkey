+Space::CapsLock
*CapsLock up:: {
    if (A_PriorKey == "CapsLock"
        and not (GetKeyState("Shift") or GetKeyState("Ctrl") or GetKeyState("Alt")
            or GetKeyState("LWin") or GetKeyState("RWin"))) {
        Send "{VK15}"
    }
}
#HotIf GetKeyState("CapsLock", "P")
Tab::^Tab
Esc::^Esc
`::+^Tab
1::^1
2::^2
3::^3
4::^4
5::^5
6::^6
7::^7
8::^8
9::^9
0::^0
BS::Del
\::^\
Enter::^Enter
a::Home
b::^Left
c::^c
d::^Del
e::End
f::^Right
g::^g
h::BS
i::Up
j::Left
k::Down
l::Right
m::^m
n::PgDn
o::Enter
p::PgUp
q::^q
r::^r
s::^s
t::^t
u::^u
v::^v
w::^w
x::^x
y::^y
z::^z
[::^[
]::^]
`;::^;
'::^'
,::^,
.::^.
/::^/
Space:: Send "{VK15}"    ; Hangul
Left:: Send "^#{Left}"   ; prev desktop
Right:: Send "^#{Right}" ; next desktop
Up:: Send "#{Tab}"       ; task view
Down:: Send "{LWin}"     ; start memu
#HotIf