-- Update the security setting on /sitecore/content item to allow create permission for the JSS Import Server Users role
-- This is a workaround since post-deploy package events do not fire in Docker

USE [Sitecore.Master]

UPDATE [dbo].[SharedFields]
SET [Value] += 'ar|sitecore\JSS Import Service Users|pe|+item:create|pd|+item:create|'
WHERE ItemId = '0DE95AE4-41AB-4D01-9EB0-67441B7C2450'
  AND [FieldId] = 'DEC8D2D5-E3CF-48B6-A653-8E69E2716641'

