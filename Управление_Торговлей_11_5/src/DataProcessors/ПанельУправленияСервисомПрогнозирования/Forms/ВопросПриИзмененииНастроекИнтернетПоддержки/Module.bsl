
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбработатьПереданныеПараметры();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПолныйСбросНастроек(Команда)
	
	ПараметрЗакрытия = Новый Структура();
	ПараметрЗакрытия.Вставить("Вариант", "ПолныйСбросНастроек");
	
	Закрыть(ПараметрЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура СбросНастроекАвторизации(Команда)
	
	ПараметрЗакрытия = Новый Структура();
	ПараметрЗакрытия.Вставить("Вариант", "СбросНастроекАвторизации");
	
	Закрыть(ПараметрЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ПараметрЗакрытия = Новый Структура();
	ПараметрЗакрытия.Вставить("Вариант", "Отмена");
	
	Закрыть(ПараметрЗакрытия);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбработатьПереданныеПараметры()
	
	ИдентификаторПриложения = Параметры.ИдентификаторПриложения;
	
КонецПроцедуры

#КонецОбласти
