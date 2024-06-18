-- USER�� �ǽù� �ð��� �������� ��, �ش� USER�� CHARGED_TIME�� �����ð���ŭ ����Ǵ� Ʈ����
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

-- TRIGGER�� ����� �۵��ϴ��� ��� ����
INSERT INTO ORDERS
VALUES (3008, 2, 1009, SYSDATETIME(), 1, 5000);