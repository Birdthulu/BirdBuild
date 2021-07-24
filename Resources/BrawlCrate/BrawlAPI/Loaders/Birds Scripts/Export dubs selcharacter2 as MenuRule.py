__author__ = "mawwwk, Bird"
__version__ = "1.0"

from BrawlCrate.API import *
from BrawlCrate.API.BrawlAPI import AppPath
from BrawlCrate.NodeWrappers import *
from BrawlLib.SSBB.ResourceNodes import *
from System.Windows.Forms import ToolStripMenuItem
from System.IO import File

# For use with db_selcharacter2.pac files

# Store temp files in the BrawlCrate program folder.
# These are deleted at the end of the script.
TEMP_ARC_PATH = AppPath + "\DB_MENURULE_EXPORT_temp.pac"

SCRIPT_NAME = "Export as MenuRule_en"

# Check to ensure the context menu item is only active if it's info.pac
# Wrapper type: ARCWrapper
def EnableCheckARC(sender, event_args):
	sender.Enabled = (BrawlAPI.SelectedNode is not None and "MenuRule" in BrawlAPI.SelectedNode.Name and BrawlAPI.SelectedNode.Parent and "db_selcharacter2" in BrawlAPI.RootNode.FilePath)

# Base function to export stocks from info.pac to other appropriate locations
def export_menurule(sender, event_args):
	SELCHAR2_PATH = BrawlAPI.RootNode.FilePath
	
	# Derive build pf path from the open menumain.pac file
	MENU2_FOLDER = str(SELCHAR2_PATH).split("db_selcharacter2.pac")[0]
	MENUMAIN_PATH = MENU2_FOLDER + "\db_menumain.pac"
	message = "Exporting db_selcharacter2.pac as a MenuRule_en file inside\n" + MENU2_FOLDER
	message += "\n\nPress OK to continue."
	
	if BrawlAPI.ShowOKCancelPrompt(message, SCRIPT_NAME):
		# Export MenuRule_en as a temp .pac file
		BrawlAPI.SelectedNode.Export(TEMP_ARC_PATH)
		
		# Open existing selchar2
		BrawlAPI.OpenFile(MENUMAIN_PATH)
		
		# Replace existing child node
		BrawlAPI.RootNode.Children[0].Replace(TEMP_ARC_PATH)
		
		BrawlAPI.SaveFile()
		BrawlAPI.OpenFile(SELCHAR2_PATH)

		File.Delete(TEMP_ARC_PATH)

		BrawlAPI.ShowMessage("Export complete!", SCRIPT_NAME)
	
# Add right-click contextual menu options
BrawlAPI.AddContextMenuItem(ARCWrapper, "", "Export archive as a MenuRule_en", EnableCheckARC, ToolStripMenuItem("Export to db_menumain", None, export_menurule))
