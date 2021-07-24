__author__ = "mawwwk, Bird"
__version__ = "1.0"

from BrawlCrate.API import *
from BrawlCrate.NodeWrappers import *
from BrawlLib.SSBB.ResourceNodes import *
from BrawlLib.SSBB.ResourceNodes.ProjectPlus import *
from System.Windows.Forms import ToolStripMenuItem
from System.IO import File
from mawwwkLib import *

TRACK_FREQUENCY = 100

## Start enable check functions
# Wrapper: TLSTWrapper
def EnableCheckTLST(sender, event_args):
	node = BrawlAPI.SelectedNode
	sender.Enabled = (node is not None and node.HasChildren)

## End enable check functions
## Start loader functions

def reset_frequency(sender, event_args):
	for track in BrawlAPI.SelectedNode.Children:
		track.Frequency = TRACK_FREQUENCY

## End loader functions
## Start context menu add

BrawlAPI.AddContextMenuItem(TLSTWrapper, "", "Max all track frequencies to 100", EnableCheckTLST, ToolStripMenuItem("Max all frequency", None, reset_frequency))
