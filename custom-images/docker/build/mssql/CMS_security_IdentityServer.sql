SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;
SET NUMERIC_ROUNDABORT OFF;
GO

IF (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
				 WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'aspnet_Membership'))
BEGIN
	IF NOT (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
				 WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'UserLogins'))
	BEGIN
		PRINT N'Creating table UserLogins...'
		CREATE TABLE [UserLogins] (
				[LoginProvider] NVARCHAR (128) NOT NULL,
				[ProviderKey]   NVARCHAR (128) NOT NULL,
				[UserId]        uniqueidentifier NOT NULL,
					CONSTRAINT [PK_dbo.UserLogins] PRIMARY KEY CLUSTERED ([LoginProvider] ASC, [ProviderKey] ASC, [UserId] ASC),
				CONSTRAINT [FK_dbo.UserLogins_dbo.aspnet_Users_UserId] FOREIGN KEY ([UserId]) REFERENCES [aspnet_Users] ([UserId]) ON DELETE CASCADE
			);
			CREATE NONCLUSTERED INDEX [IX_UserId]
				ON [UserLogins]([UserId] ASC);
	END
	ELSE
		PRINT N'The table UserLogins already present';

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PersistedGrants')
	BEGIN
		CREATE TABLE [PersistedGrants] (
			[Id] bigint NOT NULL IDENTITY,
			[Key] nvarchar(200) NULL,
			[Type] nvarchar(50) NOT NULL,
			[SubjectId] nvarchar(200) NULL,
			[ClientId] nvarchar(200) NOT NULL,
			[CreationTime] datetime2 NOT NULL,
			[Expiration] datetime2 NULL,
			[Data] nvarchar(max) NOT NULL,
			[SessionId] nvarchar(100) NULL,
			[Description] nvarchar(200) NULL,
			[ConsumedTime] datetime2 NULL,
			CONSTRAINT [PK_PersistedGrants] PRIMARY KEY ([Id])
		);
	END
	ELSE
	BEGIN
		IF NOT EXISTS (
			SELECT * 
			FROM   sys.columns 
			WHERE  object_id = OBJECT_ID(N'[dbo].[PersistedGrants]') 
					AND name = 'SessionId'
		)
		BEGIN
			ALTER TABLE [PersistedGrants]
				ADD [SessionId] NVARCHAR (100) NULL
				PRINT N'Field [SessionId] added to [PersistedGrants] table';
		END

		IF NOT EXISTS (
			SELECT * 
			FROM   sys.columns 
			WHERE  object_id = OBJECT_ID(N'[dbo].[PersistedGrants]') 
					AND name = 'Description'
		)
		BEGIN
			ALTER TABLE [PersistedGrants]
				ADD [Description] NVARCHAR (200) NULL
				PRINT N'Field [Description] added to [PersistedGrants] table';
		END

		IF NOT EXISTS (
			SELECT * 
			FROM   sys.columns 
			WHERE  object_id = OBJECT_ID(N'[dbo].[PersistedGrants]') 
					AND name = 'ConsumedTime'
		)
		BEGIN
			ALTER TABLE [PersistedGrants]
				ADD [ConsumedTime] datetime2 NULL
				PRINT N'Field [ConsumedTime] added to [PersistedGrants] table';
		END

		IF NOT EXISTS (
			SELECT * 
			FROM   sys.columns 
			WHERE  object_id = OBJECT_ID(N'[dbo].[PersistedGrants]') 
					AND name = 'Id'
		)
		BEGIN
			ALTER TABLE [PersistedGrants] ADD [Id] bigint NOT NULL IDENTITY;
			ALTER TABLE [PersistedGrants] DROP CONSTRAINT [PK_PersistedGrants];
			ALTER TABLE [PersistedGrants] ALTER COLUMN [Key] nvarchar(200) NULL;
			ALTER TABLE [PersistedGrants] ADD CONSTRAINT [PK_PersistedGrants] PRIMARY KEY ([Id]);
			PRINT N'Field [Id] added to [PersistedGrants] table';
		END
	END
	
	IF NOT EXISTS(
		SELECT * 
		FROM sys.indexes 
		WHERE object_id = OBJECT_ID(N'[dbo].[PersistedGrants]') 
			AND name = 'IX_PersistedGrants_SubjectId_SessionId_Type'
	)
	BEGIN
		CREATE INDEX [IX_PersistedGrants_SubjectId_SessionId_Type] ON [PersistedGrants] ([SubjectId] ASC, [SessionId] ASC, [Type] ASC);
		PRINT N'Index [IX_PersistedGrants_SubjectId_SessionId_Type] created for [PersistedGrants] table';
	END

	IF NOT EXISTS(
		SELECT * 
		FROM sys.indexes 
		WHERE object_id = OBJECT_ID(N'[dbo].[PersistedGrants]') 
			AND name = 'IX_PersistedGrants_SubjectId_ClientId_Type'
	)
	BEGIN
		CREATE INDEX [IX_PersistedGrants_SubjectId_ClientId_Type] ON [PersistedGrants] ([SubjectId] ASC, [ClientId] ASC, [Type] ASC);
		PRINT N'Index [IX_PersistedGrants_SubjectId_ClientId_Type] created for [PersistedGrants] table';
	END		

	IF NOT EXISTS(
		SELECT * 
		FROM sys.indexes 
		WHERE object_id = OBJECT_ID(N'[dbo].[PersistedGrants]') 
			AND name = 'IX_PersistedGrants_Expiration'
	)
	BEGIN
		CREATE INDEX [IX_PersistedGrants_Expiration] ON [PersistedGrants] ([Expiration]);
		PRINT N'Index [IX_PersistedGrants_Expiration] created for [PersistedGrants] table';
	END		

	IF NOT EXISTS(
		SELECT * 
		FROM sys.indexes 
		WHERE object_id = OBJECT_ID(N'[dbo].[PersistedGrants]') 
			AND name = 'IX_PersistedGrants_ConsumedTime'
	)
	BEGIN
		CREATE INDEX [IX_PersistedGrants_ConsumedTime] ON [PersistedGrants] ([ConsumedTime]);
		PRINT N'Index [IX_PersistedGrants_ConsumedTime] created for [PersistedGrants] table';
	END	

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DeviceCodes')
	BEGIN
		CREATE TABLE [DeviceCodes] (
			[UserCode] nvarchar(200) NOT NULL,
			[DeviceCode] nvarchar(200) NOT NULL,
			[SubjectId] nvarchar(200) NULL,
			[ClientId] nvarchar(200) NOT NULL,
			[CreationTime] datetime2 NOT NULL,
			[Expiration] datetime2 NOT NULL,
			[Data] nvarchar(max) NOT NULL,
			[SessionId] nvarchar(100) NULL,
			[Description] nvarchar(200) NULL,
			CONSTRAINT [PK_DeviceCodes] PRIMARY KEY ([UserCode])
		);
    
		CREATE UNIQUE INDEX [IX_DeviceCodes_DeviceCode] ON [DeviceCodes] ([DeviceCode]);
		CREATE INDEX [IX_DeviceCodes_Expiration] ON [DeviceCodes] ([Expiration]);
	END
	ELSE
	BEGIN
		IF NOT EXISTS (
			SELECT * 
			FROM   sys.columns 
			WHERE  object_id = OBJECT_ID(N'[dbo].[DeviceCodes]') 
					AND name = 'SessionId'
		)
		BEGIN
			ALTER TABLE [DeviceCodes]
				ADD [SessionId] NVARCHAR (100) NULL
				PRINT N'Field [SessionId] added to [DeviceCodes] table';
		END

		IF NOT EXISTS (
			SELECT * 
			FROM   sys.columns 
			WHERE  object_id = OBJECT_ID(N'[dbo].[DeviceCodes]') 
					AND name = 'Description'
		)
		BEGIN
			ALTER TABLE [DeviceCodes]
				ADD [Description] NVARCHAR (200) NULL
				PRINT N'Field [Description] added to [DeviceCodes] table';
		END
	END

	IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ExternalUserData')
	BEGIN
		CREATE TABLE [ExternalUserData] (
			[Key] int IDENTITY(1,1),
			[ProviderName] nvarchar(200) NOT NULL,
			[UserId] nvarchar(200) NOT NULL,
			[IsActive] bit NOT NULL,
			[Data] nvarchar(max) NOT NULL,
			CONSTRAINT [PK_ExternalUserData] PRIMARY KEY ([Key])
		);

		CREATE UNIQUE INDEX [IX_ExternalUserData_ProviderName_UserId] ON [ExternalUserData] ([ProviderName], [UserId]);
	END	
END

GO

PRINT N'Update for Sitecore.IdentityServer complete.';