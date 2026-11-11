/* See LICENSE file for copyright and license details. */

/* appearance */
static unsigned int borderpx        = 1;        /* border pixel of windows */
static unsigned int fborderpx       = 1;        /* floating windows */
static unsigned int snap            = 32;       /* snap pixel */
static int showbar                  = 1;        /* 0 means no bar */
static int topbar                   = 1;        /* 0 means bottom bar */
static const int focusonwheel       = 0;
static const char *fonts[] = {
    "Hack Nerd Font Propo:size=16",
    "Noto Color Emoji:size=16"
};
static const char dmenufont[]       = "HackNerdFontPropo-Regular:size=16";

/* colors */
static char normfgcolor[]           = "#000000";
static char normbgcolor[]           = "#000000";
static char normbordercolor[]       = "#222222";
static char selfgcolor[]            = "#000000";
static char selbgcolor[]            = "#000000";
static char selbordercolor[]        = "#ff0000";
static char statusfgcolor[]         = "#bbbbbb";
static char statusbgcolor[]         = "#000000";
static char statusbordercolor[]     = "#000000";
static char tagsel_fgcolor[]        = "#880000";
static char tagsel_bgcolor[]        = "#000000";
static char tagsel_bordercolor[]    = "#000000";
static char tagsnorm_fgcolor[]      = "#880000";
static char tagsnorm_bgcolor[]      = "#000000";
static char tagsnorm_bordercolor[]  = "#000000";
static char infosel_fgcolor[]       = "#cc0000";
static char infosel_bgcolor[]       = "#000000";
static char infosel_bordercolor[]   = "#000000";
static char infonorm_fgcolor[]      = "#cc0000";
static char infonorm_bgcolor[]      = "#000000";
static char infonorm_bordercolor[]  = "#000000";

static char *colors[][3] = {
    [SchemeNorm]     = { normfgcolor,      normbgcolor,      normbordercolor },
    [SchemeSel]      = { selfgcolor,       selbgcolor,       selbordercolor },
    [SchemeStatus]   = { statusfgcolor,    statusbgcolor,    statusbordercolor },
    [SchemeTagsSel]  = { tagsel_fgcolor,   tagsel_bgcolor,   tagsel_bordercolor },
    [SchemeTagsNorm] = { tagsnorm_fgcolor, tagsnorm_bgcolor, tagsnorm_bordercolor },
    [SchemeInfoSel]  = { infosel_fgcolor,  infosel_bgcolor,  infosel_bordercolor },
    [SchemeInfoNorm] = { infonorm_fgcolor, infonorm_bgcolor, infonorm_bordercolor },
};

static char tag_norm_fgcolor[]      = "#444444";
static char tag_norm_bgcolor[]      = "#000000";
static char tag_sel_fgcolor[]       = "#ffffff";
static char tag_sel_bgcolor[]       = "#880000";
static char tag_occupied_fgcolor[]  = "#bbbbbb";
static char tag_occupied_bgcolor[]  = "#000000";
static char tag_pinned_fgcolor[]    = "#cc0000";
static char tag_pinned_bgcolor[]    = "#000000";

static char *tagsel[][2] = {
    /* fg                   bg */
    { tag_norm_fgcolor,     tag_norm_bgcolor },
    { tag_sel_fgcolor,      tag_sel_bgcolor },
    { tag_occupied_fgcolor, tag_occupied_bgcolor },
    { tag_pinned_fgcolor,   tag_pinned_bgcolor },
};

/* tagging */
static const char *tags[] = { "", "", "", "", "", "󰏪", "󰑈", "", "󰀻", "󰍳"};

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
	{ "firefox",  NULL,       NULL,       0,            0,           -1 },
	{ "discord",  NULL,       NULL,       1 << 3,       0,           -1 },
	{ "Lollypop", NULL,       NULL,       1 << 7,       0,           -1 },
};

/* layout(s) */
static float mfact              = 0.55; /* factor of master area size [0.05..0.95] */
static int nmaster              = 1;    /* number of clients in master area */
static int resizehints          = 1;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "",      tile },    /* first entry is default */
	{ "",      NULL },    /* no layout function means floating behavior */
	{ "󰌧",      monocle },
};

/* key definitions */
#define MODKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/bash", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, NULL };
static const char *termcmd[]  = { "st", NULL };

/* Xresources preferences */
ResourcePref resources[] = {
    /* Appearance */
    { "borderpx", UINT, &borderpx },
    { "fborderpx", UINT, &fborderpx },
    { "snap", UINT, &snap },
    { "showbar", INTEGER, &showbar },
    { "topbar", INTEGER, &topbar },

    /* Layout */
    { "mfact", FLOAT, &mfact },
    { "nmaster", INTEGER, &nmaster },
    { "resizehints", INTEGER, &resizehints },

    /* Colors */
    { "normfgcolor", STRING, &normfgcolor },
    { "normbgcolor", STRING, &normbgcolor },
    { "normbordercolor", STRING, &normbordercolor },

    { "selfgcolor", STRING, &selfgcolor },
    { "selbgcolor", STRING, &selbgcolor },
    { "selbordercolor", STRING, &selbordercolor },

    { "statusfgcolor", STRING, &statusfgcolor },
    { "statusbgcolor", STRING, &statusbgcolor },
    { "statusbordercolor", STRING, &statusbordercolor },

    { "tagsel_fgcolor", STRING, &tagsel_fgcolor },
    { "tagsel_bgcolor", STRING, &tagsel_bgcolor },
    { "tagsel_bordercolor", STRING, &tagsel_bordercolor },

    { "tagsnorm_fgcolor", STRING, &tagsnorm_fgcolor },
    { "tagsnorm_bgcolor", STRING, &tagsnorm_bgcolor },
    { "tagsnorm_bordercolor", STRING, &tagsnorm_bordercolor },

    { "infosel_fgcolor", STRING, &infosel_fgcolor },
    { "infosel_bgcolor", STRING, &infosel_bgcolor },
    { "infosel_bordercolor", STRING, &infosel_bordercolor },

    { "infonorm_fgcolor", STRING, &infonorm_fgcolor },
    { "infonorm_bgcolor", STRING, &infonorm_bgcolor },
    { "infonorm_bordercolor", STRING, &infonorm_bordercolor },

    /* Tag colors */
    { "tag_norm_fgcolor", STRING, &tag_norm_fgcolor },
    { "tag_norm_bgcolor", STRING, &tag_norm_bgcolor },

    { "tag_sel_fgcolor", STRING, &tag_sel_fgcolor },
    { "tag_sel_bgcolor", STRING, &tag_sel_bgcolor },

    { "tag_occupied_fgcolor", STRING, &tag_occupied_fgcolor },
    { "tag_occupied_bgcolor", STRING, &tag_occupied_bgcolor },

    { "tag_pinned_fgcolor", STRING, &tag_pinned_fgcolor },
    { "tag_pinned_bgcolor", STRING, &tag_pinned_bgcolor },
};

static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_n,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_v,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	{ MODKEY,                       XK_i,      viewnext,       {0} },
	{ MODKEY,                       XK_u,      viewprev,       {0} },
	{ MODKEY|ShiftMask,             XK_i,      tagtonext,      {0} },
	{ MODKEY|ShiftMask,             XK_u,      tagtoprev,      {0} },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	TAGKEYS(                        XK_0,                      9)
	{ MODKEY|ControlMask|ShiftMask, XK_q,      quit,           {0} },
	{ MODKEY|ShiftMask,             XK_l,      spawn,          SHCMD("slock") },
	{ MODKEY|ShiftMask,             XK_n,      spawn,          SHCMD("playerctl next ; reload_status_bar") },
	{ MODKEY|ShiftMask,             XK_p,      spawn,          SHCMD("playerctl previous ; reload_status_bar") },



};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
