#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Собирает структуру из текстов запросов для дальнейшей проверки даты запрета.
// 
// Параметры:
// 	Запрос - Запрос - Запрос по проверке даты запрета, можно установить параметры
// Возвращаемое значение:
// 	Структура - см. ЗакрытиеМесяцаСервер.ИнициализироватьСтруктуруТекстовЗапросов
Функция ТекстЗапросаКонтрольДатыЗапрета(Запрос) Экспорт
	ИмяРегистра = Метаданные.РегистрыНакопления.ПодарочныеСертификаты.Имя;
	ИмяТаблицыИзменений = "ТаблицаИзмененийПодарочныеСертификаты"; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Таблица.Период КАК Период,
	|	НЕОПРЕДЕЛЕНО КАК Организация,
	|	&ИмяРегистра КАК ИмяРегистра,
	|	&Раздел КАК РазделДатыЗапрета
	|ИЗ
	|	&ИмяТаблицыИзменений КАК Таблица
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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли