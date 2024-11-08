-- FUNCAO PARA CALCULAR A DATA DO DOMINGO DE PASCOA -- 
--  ** Usando o Algoritmo de J.M OUDIN ** --

/*	Cada etapa calcula uma parte necessária para determinar o mês e o dia da Páscoa.
	Depende do ciclo lunar e do equinócio da primavera no hemisfério norte.   */

CREATE FUNCTION dbo.data_pascoa (@ano INT)
RETURNS DATE
AS
BEGIN
	DECLARE @mes INT;
	DECLARE @dia INT;
	DECLARE @sec INT;
	DECLARE @I INT;
	DECLARE @J INT;
	DECLARE @K INT;
	DECLARE @L INT;
	DECLARE @N INT;

	-- armazena o número do século ao dividir o ano pelo valor 100.
	SET @sec = @ano / 100;
	-- representa o ciclo lunar de 19 anos, conhecido como "número dourado" do ano, que determina a posição do ano no ciclo lunar.
	SET @N = @ano - 19 * (@ano / 19);
	-- é um fator de correção para ajustar a data da Páscoa, levando em conta o desvio nos anos bissextos e o ajuste no calendário gregoriano.
	SET @K = (@sec - 17) / 25;
	-- Calcula o "epacta" (@I), que ajuda a corrigir o ciclo lunar em relação ao ano solar. 
	-- É um valor de ajuste para alinhar as fases da lua com o ano solar e garantir que a Páscoa caia no domingo.
	SET @I = @sec - (@sec / 4) - ((@sec - @K) / 3) + 19 * @N + 15;
	SET @I = @I - 30 * (@I / 30);
	-- ajustado para garantir que caia na data correta do mês, levando em consideração os anos em que a Páscoa cai no último dia de março.
	SET @I = @I - ((@I / 28) * (1 - ((@I + 1) / 29) * (21 - @N) / 11));
	-- é um cálculo para determinar o dia da semana. 
	-- Essa etapa encontra o domingo mais próximo após a lua cheia de primavera.
	SET @J = @ano + (@ano / 4) + @I + 2 - @sec + (@sec / 4);
	SET @J = @J - 7 * (@J / 7);
	-- representa o deslocamento entre a lua cheia de primavera e o próximo domingo.
	SET @L = @I - @J;
	-- Define o mês da Páscoa. A Páscoa sempre cai em março (3) ou abril (4), e esse cálculo define o mês exato.
	SET @mes = 3 + ((@L + 40) / 44);
	-- Calcula o dia do mês para a Páscoa, com base no deslocamento @L e no mês calculado anteriormente.
	SET @dia = @L + 28 - 31 * (@mes / 4);

	RETURN CONVERT(DATE, CONCAT ( @ano ,'-' ,FORMAT(@mes ,'00') ,'-' ,FORMAT(@dia, '00') ) , 120);
END;
GO
