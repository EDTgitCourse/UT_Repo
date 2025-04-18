#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс



// Собирает структуру из текстов запросов для дальнейшей проверки даты запрета.
// 
// Параметры:
// 	Запрос - Запрос - Запрос по проверке даты запрета, можно установить параметры
// Возвращаемое значение:
// 	Структура - см. ЗакрытиеМесяцаСервер.ИнициализироватьСтруктуруТекстовЗапросов
Функция ТекстЗапросаКонтрольДатыЗапрета(Запрос) Экспорт
	ИмяРегистра = Метаданные.РегистрыНакопления.ВыручкаИСебестоимостьПродаж.Имя;
	ИмяТаблицыИзменений = "ТаблицаИзмененийВыручкаИСебестоимостьПродаж"; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Таблица.Период КАК Период,
	|	КлючиАналитикаУчетаПоПартнерам.Организация КАК Организация,
	|	&ИмяРегистра КАК ИмяРегистра,
	|	&Раздел КАК РазделДатыЗапрета
	|ИЗ
	|	&ИмяТаблицыИзменений КАК Таблица
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		РегистрСведений.АналитикаУчетаПоПартнерам КАК КлючиАналитикаУчетаПоПартнерам
	|	ПО
	|		Таблица.АналитикаУчетаПоПартнерам = КлючиАналитикаУчетаПоПартнерам.КлючАналитики
	|";
	
	ИмяПараметраИмяРегистра = "ИмяРегистра" + ИмяРегистра;
	ИмяПараметраРаздел = "Раздел" + ИмяРегистра;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ИмяРегистра", "&" + ИмяПараметраИмяРегистра);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&Раздел", "&" + ИмяПараметраРаздел);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ИмяТаблицыИзменений", ИмяТаблицыИзменений);
	
	Запрос.УстановитьПараметр(ИмяПараметраИмяРегистра, ИмяРегистра);
	Запрос.УстановитьПараметр(ИмяПараметраРаздел, "ФинансовыйКонтур");
	
	СтруктураТекстовЗапросов = ЗакрытиеМесяцаСервер.ИнициализироватьСтруктуруТекстовЗапросов(ТекстЗапроса);
	
	Возврат СтруктураТекстовЗапросов

КонецФункции

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК Т
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.АналитикаУчетаПоПартнерам КАК Т1 
	|	ПО Т.АналитикаУчетаПоПартнерам = Т1.КлючАналитики
	|;
	|РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Т1.Организация)
	|	И ЗначениеРазрешено(Т1.Партнер)
	|	И ЗначениеРазрешено(Т.Подразделение)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#КонецОбласти

#КонецЕсли
