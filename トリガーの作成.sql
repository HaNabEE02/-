-- When the USER charges the PC room time, triggering that the CHARGED_TIME of that USER changes by the charging time
CREATE TRIGGER UP_USER_TIME
ON ORDERS
AFTER INSERT
AS
BEGIN
	DECLARE @product INT;
	DECLARE @user INT;
	DECLARE @quantity INT;
	SELECT @product = inserted.PRODUCT_ID, @user = inserted.USER_ID, @quantity = inserted.quantity FROM inserted;
	
	UPDATE USERS
	SET CHARGED_TIME =
		CASE @product
			WHEN 1007 THEN CHARGED_TIME + 60 * @quantity
			WHEN 1008 THEN CHARGED_TIME + 180 * @quantity
			WHEN 1009 THEN CHARGED_TIME + 300 * @quantity
			WHEN 1010 THEN CHARGED_TIME + 720 * @quantity
			ELSE CHARGED_TIME + 0
		END
	WHERE USER_ID = @user;
END;
