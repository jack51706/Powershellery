-- This is a template for executing OS commands through SQL Server using OLE Automation Procedures.

-- Enable Show Advanced Options
sp_configure 'Show Advanced Options',1
RECONFIGURE
GO

-- Enable OLE Automation Procedures
sp_configure 'Ole Automation Procedures',1
RECONFIGURE
GO

-- Execute Command via OLE and store output in temp file
DECLARE @Shell INT
DECLARE @Shell2 INT
EXEC Sp_oacreate 'wscript.shell', @Shell Output, 5
EXEC Sp_oamethod @shell, 'run' , null, 'cmd.exe /c "echo Hello World > c:\temp\file.txt"'

-- Read results
DECLARE @libref INT
DECLARE @filehandle INT
DECLARE @FileContents varchar(8000)

EXEC sp_oacreate 'scripting.filesystemobject', @libref out 
EXEC sp_oamethod @libref, 'opentextfile', @filehandle out, 'c:\temp\file.txt', 1 
EXEC sp_oamethod @filehandle, 'readall', @FileContents out

SELECT @FileContents
GO

-- Remove temp result file
DECLARE @Shell INT
EXEC Sp_oacreate 'wscript.shell', @Shell Output, 5
EXEC Sp_oamethod @Shell, 'run' , null, 'cmd.exe /c "DEL c:\temp\file.txt"'
GO

-- Disable Show Advanced Options
sp_configure 'Show Advanced Options',1
RECONFIGURE
GO

-- Disable OLE Automation Procedures
sp_configure 'Ole Automation Procedures',1
RECONFIGURE
GO