
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыОткрытия= Новый Структура;
	ПараметрыОткрытия.Вставить("СформироватьПриОткрытии", Истина);
	
	ОткрытьФорму("Отчет.ПубликуемыеТорговыеПредложения.Форма", ПараметрыОткрытия, , ,
		ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти