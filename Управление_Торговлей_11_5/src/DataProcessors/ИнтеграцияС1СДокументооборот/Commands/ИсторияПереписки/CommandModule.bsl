#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ID", ПараметрыВыполненияКоманды.Источник.ID);
	ПараметрыФормы.Вставить("type", ПараметрыВыполненияКоманды.Источник.Тип);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ИсторияПереписки",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти