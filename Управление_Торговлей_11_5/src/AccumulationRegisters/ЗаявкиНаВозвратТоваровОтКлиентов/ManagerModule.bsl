#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Текст запроса получает остаток по ресурсам КОформлению и Заявлено
// Остаток дополняется движениями, сделанными накладной заданной в параметре Регистратор.
//
// Параметры:
//  ИмяВременнойТаблицы	 - Строка - Поместить результат во временную таблицу с заданным именем. 
//  ОтборПоИзмерениям	 - Структура - Ключ - имя измерения, Значение - имя параметра в запросе, например:
//  									Новый Структура("Номенклатура", "Товар") будет преобразовано в тексте запроса в:
//  									Номенклатура В(&Товар)
//  Выражение			 - Строка - Условие для секции ИМЕЮЩИЕ по ресурсам.
//  								Например, строка вида "КОформлению <> 0" будет преобразована в тексте запроса в:
//  								СУММА(Набор.КОформлению) <> 0
// 
// Возвращаемое значение:
//  Строка - текст запроса
//
Функция ТекстЗапросаОстатки(ИмяВременнойТаблицы = "", ОтборПоИзмерениям = Неопределено, Выражение = "") Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Набор.ЗаявкаНаВозвратТоваровОтКлиента    КАК ЗаказПоставщику,
	|	Набор.Номенклатура                       КАК Номенклатура,
	|	Набор.Характеристика                     КАК Характеристика,
	|	Набор.КодСтроки                          КАК КодСтроки,
	|	СУММА(Набор.Заказано)                    КАК Заказано,
	|	СУММА(Набор.КОформлению)                 КАК КОформлению
	|ПОМЕСТИТЬ ИмяТаблицы
	|ИЗ(
	|	ВЫБРАТЬ
	|		Таблица.ЗаявкаНаВозвратТоваровОтКлиента    КАК ЗаявкаНаВозвратТоваровОтКлиента,
	|		Таблица.Номенклатура                       КАК Номенклатура,
	|		Таблица.Характеристика                     КАК Характеристика,
	|		Таблица.КодСтроки                          КАК КодСтроки,
	|		Таблица.ЗаявленоОстаток                    КАК Заказано,
	|		Таблица.КОформлениюОстаток                 КАК КОформлению
	|	ИЗ
	|		РегистрНакопления.ЗаявкиНаВозвратТоваровОтКлиентов.Остатки(, 
	|			&ОтборПоИзмерениям
	|			) КАК Таблица
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Таблица.ЗаявкаНаВозвратТоваровОтКлиента    КАК ЗаявкаНаВозвратТоваровОтКлиента,
	|		Таблица.Номенклатура                       КАК Номенклатура,
	|		Таблица.Характеристика                     КАК Характеристика,
	|		Таблица.КодСтроки                          КАК КодСтроки,
	|		Таблица.Заявлено                           КАК Заказано,
	|		Таблица.КОформлению                        КАК КОформлению
	|	ИЗ
	|		РегистрНакопления.ЗаявкиНаВозвратТоваровОтКлиентов КАК Таблица
	|	ГДЕ
	|		Активность
	|		И Регистратор В(&Регистратор)
	|		И ВидДвижения = ЗНАЧЕНИЕ(ВидДВиженияНакопления.Расход)
	|		И &ОтборПоИзмерениям
	|	) КАК Набор
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаявкаНаВозвратТоваровОтКлиента,
	|	Номенклатура,
	|	Характеристика,
	|	КодСтроки
	|
	|,&ИМЕЮЩИЕ";
	
	Если Не ПустаяСтрока(ИмяВременнойТаблицы) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ПОМЕСТИТЬ ИмяТаблицы", "ПОМЕСТИТЬ " + ИмяВременнойТаблицы);
		ТекстЗапроса = ТекстЗапроса + 
		"
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ЗаявкаНаВозвратТоваровОтКлиента,
		|	КодСтроки";
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ПОМЕСТИТЬ ИмяТаблицы", "");
	КонецЕсли;
	
	ТекстОтбораПоИзмерениям = ОбщегоНазначенияУТ.ТекстОтбораПоКоллекцииОтборов(ОтборПоИзмерениям);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ОтборПоИзмерениям", ТекстОтбораПоИзмерениям);
	
	Если Не ПустаяСтрока(Выражение) Тогда
		
		Если СтрНайти(Выражение, "КОформлению") <> 0 Тогда
			Выражение = СтрЗаменить(Выражение, "КОформлению", "СУММА(Набор.КОформлению)");
		КонецЕсли;
		Если СтрНайти(Выражение, "Заказано") <> 0 Тогда
			Выражение = СтрЗаменить(Выражение, "Заказано", "СУММА(Набор.Заказано)");
		КонецЕсли;
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ",&ИМЕЮЩИЕ", "ИМЕЮЩИЕ " + Выражение);
		
	Иначе
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ",&ИМЕЮЩИЕ", "");
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ЗаявкаНаВозвратТоваровОтКлиента.Организация)
	|	И ЗначениеРазрешено(ЗаявкаНаВозвратТоваровОтКлиента.Партнер)
	|	И ЗначениеРазрешено(ЗаявкаНаВозвратТоваровОтКлиента.Склад)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли