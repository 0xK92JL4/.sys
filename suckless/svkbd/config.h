/* See LICENSE file for copyright and license details. */

static const Bool wmborder = True;

static int fontsize = 18;

/* overlay delay in seconds */
static double overlay_delay = 1.0;

/* repeat delay in seconds, will not work on keys with overlays */
static double repeat_delay = 0.75;

/* scan rate in microseconds, affects key repetition rate */
static int scan_rate = 50;

/* one row of keys takes up 1/x of the screen height */
static int heightfactor = 14;

static int xspacing = 2;
static int yspacing = 2;

static const char *defaultfonts[] = {
	"Hack Nerd Font Propo:bold:size=18",
	"Noto Color Emoji:size=18"
};

static const char *defaultcolors[SchemeLast][2] = {
	/*                           fg         bg       */

	[SchemeNorm]           = { "#b1bac4", "#1a1d21" },
	[SchemeNormShift]      = { "#54292F", "#1a1d21" },

	[SchemeNormABC]        = { "#e6edf3", "#23272e" },
	[SchemeNormABCShift]   = { "#54292F", "#23272e" },

	[SchemePress]          = { "#ffffff", "#e85d75" },
	[SchemePressShift]     = { "#ffffff", "#e85d75" },

	[SchemeHighlight]      = { "#ffffff", "#ba405a" },
	[SchemeHighlightShift] = { "#ffffff", "#e85d75" },

	[SchemeOverlay]        = { "#b1bac4", "#2d333b" },
	[SchemeOverlayShift]   = { "#54292F", "#2d333b" },

	[SchemeWindow]         = { "#e6edf3", "#111315" },
};
