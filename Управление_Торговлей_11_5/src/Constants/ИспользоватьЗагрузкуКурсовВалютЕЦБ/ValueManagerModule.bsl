#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Значение Тогда
		Валюта = Справочники.Валюты.НайтиПоКоду("978");
		Если ЗначениеЗаполнено(Валюта) Тогда
			РаботаСКурсамиВалютУТ.ПроверитьКорректностьОтносительногоКурсаНа01_01_1980(Валюта);
		Иначе
			ТекстОшибки = НСтр("ru = 'Включение функции невозможно. В справочнике ""Валюты"" отсутствует Евро (EUR).'");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки,,,,Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли