#Область СлужебныеПроцедурыИФункции

// Методы к выполнению.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - Методы к выполнению:
// * Обработка - Строка - Имя действия, которое требуется произвести над строкой табличной части.
// * Метод - Строка - Путь к экспортному методу, который выполняет указанное в колонке Обработка действие. 
// * Порядок - Число - Приоритет выполнения действия над строкой.
//
Функция МетодыКВыполнению() Экспорт

	Соответствие 	= Новый СписокЗначений();
	
	СоответствиеТЗ 	= Новый ТаблицаЗначений();
	СоответствиеТЗ.Колонки.Добавить("Обработка", Новый ОписаниеТипов("Строка")); 
	СоответствиеТЗ.Колонки.Добавить("Метод", Новый ОписаниеТипов("Строка")); 
	СоответствиеТЗ.Колонки.Добавить("Порядок", Новый ОписаниеТипов("Число")); 
	
	ПакетнаяОбработкаТабличнойЧастиСервер.ПриДобавленииОбработчиковСтрокКоллекции(Соответствие);
		
	СоответствиеТЗ.Индексы.Добавить("Обработка");
	
	Счетчик = 1;
	
	Для каждого Обработка Из Соответствие Цикл
		НоваяСтрока				= СоответствиеТЗ.Добавить();
		НоваяСтрока.Обработка	= Обработка.Значение;
		НоваяСтрока.Метод		= Обработка.Представление;
		НоваяСтрока.Порядок		= Счетчик;
		Счетчик					= Счетчик + 1;
	КонецЦикла;
	
	Возврат СоответствиеТЗ;
	
КонецФункции

#КонецОбласти