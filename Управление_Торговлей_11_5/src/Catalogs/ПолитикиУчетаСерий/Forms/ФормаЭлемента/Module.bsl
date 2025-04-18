
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Объект.Предопределенный Тогда
		ТекстИсключения = НСтр("ru = 'Это служебная политика учета серий, редактирование запрещено.'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Если Не ЗначениеЗаполнено(Объект.ТипПолитики)
			И Не ПолучитьФункциональнуюОпцию("ИспользоватьОрдерныеСклады") Тогда
			Объект.ТипПолитики = Перечисления.ТипыПолитикУказанияСерий.СправочноеУказаниеСерий;
		КонецЕсли;
		
		ТипПолитикиПриИзмененииНаСервере();
		УстановитьНастройкуПриЧтенииСоздании();
	Иначе
		Элементы.НастройкаУказанияСерийПриОтгрузке.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	
	Если ИспользуетсяПроизводство21 Тогда
		
		Если ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация") Тогда
			Элементы.УказыватьПриПроизводствеПродукции.Видимость = Ложь;
			Элементы.УказыватьПриРасходеМатериалов.Видимость = Ложь;
		Иначе
			Элементы.УказыватьПриОтгрузкеНаВнутренниеНужды.Заголовок = НСтр("ru = 'в производство, на внутренние нужды'");
		КонецЕсли;
		
		Если ИспользуетсяПроизводство22 Тогда
			Элементы.УказыватьПриПроизводствеПродукции.Заголовок = НСтр("ru = 'при вводе выходных изделий в маршрутных листах и этапах производства'");
		Иначе
			Элементы.УказыватьПриПроизводствеПродукции.Заголовок = НСтр("ru = 'при вводе выходных изделий в маршрутных листах'");
		КонецЕсли;
		
	Иначе
		
		Если ИспользуетсяПроизводство22 Тогда
			Элементы.УказыватьПриПроизводствеПродукции.Заголовок = НСтр("ru = 'при выпуске продукции'");
		КонецЕсли;
		
		Элементы.ДекорацияУказыватьПриДвиженииМатериалов1.Видимость = Ложь;
		Элементы.ДекорацияУказыватьПриДвиженииМатериалов2.Видимость = Ложь;
		
	КонецЕсли;
	
	Элементы.УчетСерийВНеотфактурованныхПоставкахТоваров.Видимость =
		ПолучитьФункциональнуюОпцию("ИспользоватьНеотфактурованныеПоставки");
	Элементы.УчетТоваровВПутиОтПоставщикаПоСериям.Видимость =
		ПолучитьФункциональнуюОпцию("ИспользоватьТоварыВПутиОтПоставщиков");
	Элементы.УчетСерийВПереданныхНаХранениеТоварах.Видимость =
		ПолучитьФункциональнуюОпцию("ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи");
	
	Элементы.УчетСерийПереданныхПереработчикуТоваров.Видимость = Ложь;
	Элементы.УчетСерийВПереданныхНаКомиссиюТоваров.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриПродажах")
																И ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСКлиентами");
	ЗаполнитьСписокТиповПолитик();
	НастроитьЭлементыФормыНаСервере();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	УстановитьНастройкуПриЧтенииСоздании();

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Объект.УказыватьПриПланированииОтгрузки = (НастройкаУказанияСерийПриОтгрузке = "ПриПланированииОтгрузки");
	Объект.УказыватьПриПланированииОтбора   = (НастройкаУказанияСерийПриОтгрузке = "ПриПланированииОтбора");
	Объект.УказыватьПоФактуОтбора           = (НастройкаУказанияСерийПриОтгрузке = "ПоФактуОтбора");
КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтотОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтотОбъект, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипПолитикиПриИзменении(Элемент)
	
	ТипПолитикиПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УказыватьПриПриемкеПриИзменении(Элемент)
	Если Не Объект.УказыватьПриПриемке Тогда
		
		Объект.УказыватьПриПриемкеКомплектующихПослеРазборки    = Ложь;
		Объект.УказыватьПриПриемкеОтПоставщика                  = Ложь;
		Объект.УказыватьПриПриемкеПоВозвратуОтКлиента           = Ложь;
		Объект.УказыватьПриВозвратеНепринятыхПолучателемТоваров = Ложь;
		Объект.УказыватьПриПриемкеПоПеремещению                 = Ложь;
		Объект.УказыватьПриПриемкеПоПрочемуОприходованию        = Ложь;
		Объект.УказыватьПриПриемкеСобранныхКомплектов           = Ложь;
		Объект.УказыватьПриПриемкеПродукцииИзПроизводства       = Ложь;
		
	КонецЕсли;
	
	НастроитьЭлементыФормыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура УказыватьПриОтгрузкеПриИзменении(Элемент)
	Если Не Объект.УказыватьПриОтгрузке Тогда
		
		Объект.УказыватьПриОтгрузкеКлиенту                = Ложь;
		Объект.УказыватьПриОтгрузкеВРозницу               = Ложь;
		Объект.УказыватьПриОтгрузкеКомплектовДляРазборки  = Ложь;
		Объект.УказыватьПриОтгрузкеКомплектующихДляСборки = Ложь;
		Объект.УказыватьПриОтгрузкеНаВнутренниеНужды      = Ложь;
		Объект.УказыватьПриОтгрузкеПоВозвратуПоставщику   = Ложь;
		Объект.УказыватьПриОтгрузкеПоПеремещению          = Ложь;
		
		НастройкаУказанияСерийПриОтгрузке = "";
	Иначе
		НастройкаУказанияСерийПриОтгрузке = "ПоФактуОтбора";
	КонецЕсли;
	
	НастроитьЭлементыФормыНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура УказыватьПриДвиженииМатериаловПриИзменении(Элемент)
	
	Если Не Объект.УказыватьПриДвиженииМатериалов Тогда
		
		Объект.УказыватьПриПолученииМатериалов = Ложь;
		Объект.УказыватьПриВозвратеНаСклад = Ложь;
		Объект.УказыватьПриРасходеМатериалов = Ложь;
		Объект.УказыватьПриОтраженииЗатратНаПроизводство = Ложь;
		
	КонецЕсли;
	
	НастроитьЭлементыФормыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УказыватьПриДвиженииПродукцииПриИзменении(Элемент)
	
	Если Не Объект.УказыватьПриДвиженииПродукции Тогда
		
		Объект.УказыватьПриПроизводствеПродукции = Ложь;
		Объект.УказыватьПриВыпускеВПодразделение = Ложь;
		
	КонецЕсли;
	
	НастроитьЭлементыФормыНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УказыватьПриРасходеМатериаловПриИзменении(Элемент)
	
	Если НЕ ИспользуетсяПроизводство21 И ИспользуетсяПроизводство22 Тогда
		
		Объект.УказыватьПриДвиженииМатериалов = Объект.УказыватьПриРасходеМатериалов;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УказыватьПриПроизводствеПродукцииПриИзменении(Элемент)
	
	Если НЕ ИспользуетсяПроизводство21 И ИспользуетсяПроизводство22 Тогда
		
		Объект.УказыватьПриДвиженииПродукции = Объект.УказыватьПриПроизводствеПродукции;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Обработчик команды, создаваемой механизмом запрета редактирования ключевых реквизитов.
//
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	Если Не Объект.Ссылка.Пустая() Тогда
		ОткрытьФорму("Справочник.ПолитикиУчетаСерий.Форма.РазблокированиеРеквизитов",,,,,, 
			Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект), 
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Массив")
		И Результат.Количество() > 0 Тогда
		
		ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтотОбъект, Результат);
		
		Элементы.НастройкаУказанияСерийПриОтгрузке.ТолькоПросмотр = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура УстановитьНастройкуПриЧтенииСоздании()
	
	Если Объект.УказыватьПриПланированииОтгрузки Тогда
		НастройкаУказанияСерийПриОтгрузке = "ПриПланированииОтгрузки";
	ИначеЕсли Объект.УказыватьПриПланированииОтбора Тогда
		НастройкаУказанияСерийПриОтгрузке = "ПриПланированииОтбора";
	ИначеЕсли Объект.УказыватьПоФактуОтбора Тогда
		НастройкаУказанияСерийПриОтгрузке = "ПоФактуОтбора";
	КонецЕсли;
	
	НастроитьЭлементыФормыНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормыНаСервере()
	
	ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач = ПолучитьФункциональнуюОпцию("ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач");
	
	
	Если Объект.ТипПолитики = Перечисления.ТипыПолитикУказанияСерий.СправочноеУказаниеСерий Тогда
		
		Элементы.УказыватьПриПриемкеПоВозвратуОтКлиента.Доступность           = Объект.УказыватьПриПриемке;
		Элементы.УказыватьПриВозвратеНепринятыхПолучателемТоваров.Доступность = Объект.УказыватьПриПриемке;
		Элементы.УказыватьПриПриемкеОтПоставщика.Доступность                  = Объект.УказыватьПриПриемке;
		Элементы.УказыватьПриПриемкеПоПеремещению.Доступность                 = Объект.УказыватьПриПриемке;
		Элементы.УказыватьПриПриемкеСобранныхКомплектов.Доступность           = Объект.УказыватьПриПриемке;
		Элементы.УказыватьПриПриемкеКомплектующихПослеРазборки.Доступность    = Объект.УказыватьПриПриемке;
		Элементы.УказыватьПриПриемкеПоПрочемуОприходованию.Доступность        = Объект.УказыватьПриПриемке;
		Элементы.УказыватьПриПриемкеПродукцииИзПроизводства.Доступность       = Объект.УказыватьПриПриемке;
		
		Элементы.УказыватьПриОтгрузкеКлиенту.Доступность                = Объект.УказыватьПриОтгрузке;
		Элементы.УказыватьПриОтгрузкеВРозницу.Доступность               = Объект.УказыватьПриОтгрузке;
		Элементы.УказыватьПриОтгрузкеКомплектующихДляСборки.Доступность = Объект.УказыватьПриОтгрузке;
		Элементы.УказыватьПриОтгрузкеНаВнутренниеНужды.Доступность      = Объект.УказыватьПриОтгрузке;
		Элементы.УказыватьПриОтгрузкеПоВозвратуПоставщику.Доступность   = Объект.УказыватьПриОтгрузке;
		Элементы.УказыватьПриОтгрузкеПоПеремещению.Доступность          = Объект.УказыватьПриОтгрузке;
		Элементы.УказыватьПриОтгрузкеКомплектовДляРазборки.Доступность  = Объект.УказыватьПриОтгрузке;
		
		Элементы.УказыватьПриОтраженииИзлишков.Доступность              = ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач;
		Элементы.УказыватьПриПеремещенииМеждуПомещениями.Доступность    = Истина;
		Элементы.УказыватьПриПриемке.Доступность                        = Истина;
		Элементы.УказыватьПриОтгрузке.Доступность                       = Истина;
		Элементы.НастройкаУказанияСерийПриОтгрузке.Доступность          = Ложь;
		
		
		Элементы.УчетСерийВПереданныхНаХранениеТоварах.Доступность       = Ложь;
		Элементы.УчетСерийВПереданныхНаКомиссиюТоваров.Доступность       = Ложь;
		Элементы.УчетСерийВНеотфактурованныхПоставкахТоваров.Доступность = Ложь;
		Элементы.УчетТоваровВПутиОтПоставщикаПоСериям.Доступность        = Ложь;
		
	ИначеЕсли Объект.ТипПолитики = Перечисления.ТипыПолитикУказанияСерий.АвторасчетПоFEFOОстатковСерий Тогда
		
		Элементы.УказыватьПриПриемкеПоВозвратуОтКлиента.Доступность           = Ложь;
		Элементы.УказыватьПриВозвратеНепринятыхПолучателемТоваров.Доступность = Ложь;
		Элементы.УказыватьПриПриемкеОтПоставщика.Доступность                  = Ложь;
		Элементы.УказыватьПриПриемкеПоПеремещению.Доступность                 = Ложь;
		Элементы.УказыватьПриПриемкеСобранныхКомплектов.Доступность           = Ложь;
		Элементы.УказыватьПриПриемкеКомплектующихПослеРазборки.Доступность    = Ложь;
		Элементы.УказыватьПриПриемкеПоПрочемуОприходованию.Доступность        = Ложь;
		Элементы.УказыватьПриПриемкеПродукцииИзПроизводства.Доступность       = Ложь;
		
		Элементы.УказыватьПриОтгрузкеКлиенту.Доступность                = Ложь;
		Элементы.УказыватьПриОтгрузкеВРозницу.Доступность               = Ложь;
		Элементы.УказыватьПриОтгрузкеКомплектующихДляСборки.Доступность = Ложь;
		Элементы.УказыватьПриОтгрузкеНаВнутренниеНужды.Доступность      = Ложь;
		Элементы.УказыватьПриОтгрузкеПоВозвратуПоставщику.Доступность   = Ложь;
		Элементы.УказыватьПриОтгрузкеПоПеремещению.Доступность          = Ложь;
		Элементы.УказыватьПриОтгрузкеКомплектовДляРазборки.Доступность  = Ложь;
		
		Элементы.УказыватьПриОтраженииИзлишков.Доступность              = Ложь;
		Элементы.УказыватьПриПеремещенииМеждуПомещениями.Доступность    = Ложь;
		Элементы.УказыватьПриПриемке.Доступность                        = Ложь;
		Элементы.УказыватьПриОтгрузке.Доступность                       = Ложь;
		Элементы.НастройкаУказанияСерийПриОтгрузке.Доступность          = Ложь;
		
		
		Элементы.УчетСерийВПереданныхНаХранениеТоварах.Доступность       = Ложь;
		Элементы.УчетСерийВПереданныхНаКомиссиюТоваров.Доступность       = Ложь;
		Элементы.УчетСерийВНеотфактурованныхПоставкахТоваров.Доступность = Ложь;
		Элементы.УчетТоваровВПутиОтПоставщикаПоСериям.Доступность        = Ложь;
		
	ИначеЕсли Объект.ТипПолитики = Перечисления.ТипыПолитикУказанияСерий.УправлениеОстаткамиСерий
		Или Объект.ТипПолитики = Перечисления.ТипыПолитикУказанияСерий.УправлениеПоFEFOОстаткамиСерий Тогда
		
		Элементы.УказыватьПриПриемкеПоВозвратуОтКлиента.Доступность           = Ложь;
		Элементы.УказыватьПриВозвратеНепринятыхПолучателемТоваров.Доступность = Ложь;
		Элементы.УказыватьПриПриемкеОтПоставщика.Доступность                  = Ложь;
		Элементы.УказыватьПриПриемкеПоПеремещению.Доступность                 = Ложь;
		Элементы.УказыватьПриПриемкеСобранныхКомплектов.Доступность           = Ложь;
		Элементы.УказыватьПриПриемкеКомплектующихПослеРазборки.Доступность    = Ложь;
		Элементы.УказыватьПриПриемкеПоПрочемуОприходованию.Доступность        = Ложь;
		Элементы.УказыватьПриПриемкеПродукцииИзПроизводства.Доступность       = Ложь;
		
		Элементы.УказыватьПриОтгрузкеКлиенту.Доступность                = Ложь;
		Элементы.УказыватьПриОтгрузкеВРозницу.Доступность               = Ложь;
		Элементы.УказыватьПриОтгрузкеКомплектующихДляСборки.Доступность = Ложь;
		Элементы.УказыватьПриОтгрузкеНаВнутренниеНужды.Доступность      = Ложь;
		Элементы.УказыватьПриОтгрузкеПоВозвратуПоставщику.Доступность   = Ложь;
		Элементы.УказыватьПриОтгрузкеПоПеремещению.Доступность          = Ложь;
		Элементы.УказыватьПриОтгрузкеКомплектовДляРазборки.Доступность  = Ложь;
		
		Элементы.УказыватьПриОтраженииИзлишков.Доступность              = Ложь;
		Элементы.УказыватьПриПеремещенииМеждуПомещениями.Доступность    = Ложь;
		Элементы.УказыватьПриПриемке.Доступность                        = Ложь;
		Элементы.УказыватьПриОтгрузке.Доступность                       = Ложь;
		
		Элементы.НастройкаУказанияСерийПриОтгрузке.Доступность =
			(Объект.ТипПолитики = Перечисления.ТипыПолитикУказанияСерий.УправлениеОстаткамиСерий);
			
		
		Элементы.УчетСерийВПереданныхНаХранениеТоварах.Доступность       = Ложь;
		Элементы.УчетСерийВПереданныхНаКомиссиюТоваров.Доступность       = Ложь;
		Элементы.УчетСерийВНеотфактурованныхПоставкахТоваров.Доступность = Ложь;
		Элементы.УчетТоваровВПутиОтПоставщикаПоСериям.Доступность        = Ложь;
		
	ИначеЕсли Объект.ТипПолитики = Перечисления.ТипыПолитикУказанияСерий.УчетСебестоимостиПоСериям Тогда
		
		Элементы.УказыватьПриПриемкеПоВозвратуОтКлиента.Доступность           = Ложь;
		Элементы.УказыватьПриВозвратеНепринятыхПолучателемТоваров.Доступность = Ложь;
		Элементы.УказыватьПриПриемкеОтПоставщика.Доступность                  = Ложь;
		Элементы.УказыватьПриПриемкеПоПеремещению.Доступность                 = Ложь;
		Элементы.УказыватьПриПриемкеСобранныхКомплектов.Доступность           = Ложь;
		Элементы.УказыватьПриПриемкеКомплектующихПослеРазборки.Доступность    = Ложь;
		Элементы.УказыватьПриПриемкеПоПрочемуОприходованию.Доступность        = Ложь;
		Элементы.УказыватьПриПриемкеПродукцииИзПроизводства.Доступность       = Ложь;
		
		Элементы.УказыватьПриОтгрузкеКлиенту.Доступность                = Ложь;
		Элементы.УказыватьПриОтгрузкеВРозницу.Доступность               = Ложь;
		Элементы.УказыватьПриОтгрузкеКомплектующихДляСборки.Доступность = Ложь;
		Элементы.УказыватьПриОтгрузкеНаВнутренниеНужды.Доступность      = Ложь;
		Элементы.УказыватьПриОтгрузкеПоВозвратуПоставщику.Доступность   = Ложь;
		Элементы.УказыватьПриОтгрузкеПоПеремещению.Доступность          = Ложь;
		Элементы.УказыватьПриОтгрузкеКомплектовДляРазборки.Доступность  = Ложь;
		
		Элементы.УказыватьПриОтраженииИзлишков.Доступность              = Ложь;
		Элементы.УказыватьПриПеремещенииМеждуПомещениями.Доступность    = Ложь;
		Элементы.УказыватьПриПриемке.Доступность                        = Ложь;
		Элементы.УказыватьПриОтгрузке.Доступность                       = Ложь;
		
		Элементы.НастройкаУказанияСерийПриОтгрузке.Доступность          = Ложь;
		
		
		Элементы.УчетСерийВПереданныхНаХранениеТоварах.Доступность       = Истина;
		Элементы.УчетСерийВПереданныхНаКомиссиюТоваров.Доступность       = Истина;
		Элементы.УчетСерийВНеотфактурованныхПоставкахТоваров.Доступность = Истина;
		Элементы.УчетТоваровВПутиОтПоставщикаПоСериям.Доступность        = Истина;
		
	КонецЕсли;
	
	НастроитьЭлементыФормыНаСервереЛокализация(ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач);
	
КонецПроцедуры

&НаСервере
Процедура ТипПолитикиПриИзмененииНаСервере()
	
	Если Не ЗначениеЗаполнено(Объект.ТипПолитики) Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.ТипПолитики = Перечисления.ТипыПолитикУказанияСерий.СправочноеУказаниеСерий Тогда
		Объект.УчетСерийПоFEFO                = Ложь;
		Объект.УчитыватьОстаткиСерий          = Ложь;
		Объект.УчитыватьСебестоимостьПоСериям = Ложь;
		
		Если Объект.УказыватьПриОтгрузке Тогда
			НастройкаУказанияСерийПриОтгрузке = "ПоФактуОтбора";
		Иначе
			НастройкаУказанияСерийПриОтгрузке = "";
		КонецЕсли;
		
		Объект.УказыватьПриПересчетеТоваров  = Ложь;
		Объект.УказыватьПриОтраженииНедостач = Ложь;
		
		Объект.УчетСерийВНеотфактурованныхПоставкахТоваров = Ложь;
		Объект.УчетТоваровВПутиОтПоставщикаПоСериям        = Ложь;
		
		Объект.УчетСерийВПереданныхНаКомиссиюТоваров = Ложь;
		
	ИначеЕсли Объект.ТипПолитики = Перечисления.ТипыПолитикУказанияСерий.АвторасчетПоFEFOОстатковСерий Тогда
		Объект.УчетСерийПоFEFO                     = Ложь;
		Объект.УчитыватьОстаткиСерий               = Ложь;
		Объект.УчитыватьСебестоимостьПоСериям = Ложь;
		
		Объект.УказыватьПриОтгрузке                       = Ложь;
		Объект.УказыватьПриОтгрузкеКлиенту                = Ложь;
		Объект.УказыватьПриОтгрузкеВРозницу               = Ложь;
		Объект.УказыватьПриОтгрузкеКомплектующихДляСборки = Ложь;
		Объект.УказыватьПриОтгрузкеНаВнутренниеНужды      = Ложь;
		Объект.УказыватьПриОтгрузкеПоВозвратуПоставщику   = Ложь;
		Объект.УказыватьПриОтгрузкеПоПеремещению          = Ложь;
		Объект.УказыватьПриОтгрузкеКомплектовДляРазборки  = Ложь;
		
		НастройкаУказанияСерийПриОтгрузке = "";
		
		Объект.УказыватьПриПриемке                              = Истина;
		Объект.УказыватьПриПриемкеПоВозвратуОтКлиента           = Истина;
		Объект.УказыватьПриВозвратеНепринятыхПолучателемТоваров = Истина;
		Объект.УказыватьПриПриемкеОтПоставщика                  = Истина;
		Объект.УказыватьПриПриемкеПоПеремещению                 = Истина;
		Объект.УказыватьПриПриемкеСобранныхКомплектов           = Истина;
		Объект.УказыватьПриПриемкеКомплектующихПослеРазборки    = Истина;
		Объект.УказыватьПриПриемкеПоПрочемуОприходованию        = Истина;
		Объект.УказыватьПриПриемкеПродукцииИзПроизводства       = Истина;
		
		Объект.УказыватьПриОтраженииИзлишков = Истина;
		Объект.УказыватьПриОтраженииНедостач = Ложь;
		Объект.УказыватьПриПересчетеТоваров  = Ложь;
		
		Объект.УказыватьПриПеремещенииМеждуПомещениями = Истина;
		
		
		Объект.УчетСерийВПереданныхНаКомиссиюТоваров       = Ложь;
		Объект.УчетСерийВНеотфактурованныхПоставкахТоваров = Ложь;
		Объект.УчетТоваровВПутиОтПоставщикаПоСериям        = Ложь;
		
	ИначеЕсли Объект.ТипПолитики = Перечисления.ТипыПолитикУказанияСерий.УправлениеОстаткамиСерий Тогда
		Объект.УчетСерийПоFEFO                     = Ложь;
		Объект.УчитыватьСебестоимостьПоСериям = Ложь;
		Объект.УчитыватьОстаткиСерий               = Истина;
		
		Объект.УказыватьПриОтгрузке                       = Истина;
		Объект.УказыватьПриОтгрузкеКлиенту                = Истина;
		Объект.УказыватьПриОтгрузкеВРозницу               = Истина;
		Объект.УказыватьПриОтгрузкеКомплектующихДляСборки = Истина;
		Объект.УказыватьПриОтгрузкеНаВнутренниеНужды      = Истина;
		Объект.УказыватьПриОтгрузкеПоВозвратуПоставщику   = Истина;
		Объект.УказыватьПриОтгрузкеПоПеремещению          = Истина;
		Объект.УказыватьПриОтгрузкеКомплектовДляРазборки  = Истина;
		
		Объект.УказыватьПриПриемке                              = Истина;
		Объект.УказыватьПриПриемкеПоВозвратуОтКлиента           = Истина;
		Объект.УказыватьПриВозвратеНепринятыхПолучателемТоваров = Истина;
		Объект.УказыватьПриПриемкеОтПоставщика                  = Истина;
		Объект.УказыватьПриПриемкеПоПеремещению                 = Истина;
		Объект.УказыватьПриПриемкеСобранныхКомплектов           = Истина;
		Объект.УказыватьПриПриемкеКомплектующихПослеРазборки    = Истина;
		Объект.УказыватьПриПриемкеПоПрочемуОприходованию        = Истина;
		Объект.УказыватьПриПриемкеПродукцииИзПроизводства       = Истина;
		
		Объект.УказыватьПриОтраженииИзлишков = Истина;
		Объект.УказыватьПриОтраженииНедостач = Истина;
		Объект.УказыватьПриПересчетеТоваров  = Истина;
		
		Объект.УказыватьПриПеремещенииМеждуПомещениями = Истина;
		
		
		Объект.УчетСерийВПереданныхНаКомиссиюТоваров       = Ложь;
		Объект.УчетСерийВНеотфактурованныхПоставкахТоваров = Ложь;
		Объект.УчетТоваровВПутиОтПоставщикаПоСериям        = Ложь;
		
	ИначеЕсли Объект.ТипПолитики = Перечисления.ТипыПолитикУказанияСерий.УправлениеПоFEFOОстаткамиСерий Тогда
		Объект.УчетСерийПоFEFO                     = Истина;
		Объект.УчитыватьСебестоимостьПоСериям = Ложь;
		Объект.УчитыватьОстаткиСерий               = Истина;
		НастройкаУказанияСерийПриОтгрузке          = "ПриПланированииОтбора";
		
		Объект.УказыватьПриОтгрузке                       = Истина;
		Объект.УказыватьПриОтгрузкеКлиенту                = Истина;
		Объект.УказыватьПриОтгрузкеВРозницу               = Истина;
		Объект.УказыватьПриОтгрузкеКомплектующихДляСборки = Истина;
		Объект.УказыватьПриОтгрузкеНаВнутренниеНужды      = Истина;
		Объект.УказыватьПриОтгрузкеПоВозвратуПоставщику   = Истина;
		Объект.УказыватьПриОтгрузкеПоПеремещению          = Истина;
		Объект.УказыватьПриОтгрузкеКомплектовДляРазборки  = Истина;
		
		Объект.УказыватьПриПриемке                              = Истина;
		Объект.УказыватьПриПриемкеПоВозвратуОтКлиента           = Истина;
		Объект.УказыватьПриВозвратеНепринятыхПолучателемТоваров = Истина;
		Объект.УказыватьПриПриемкеОтПоставщика                  = Истина;
		Объект.УказыватьПриПриемкеПоПеремещению                 = Истина;
		Объект.УказыватьПриПриемкеПоПрочемуОприходованию        = Истина;
		Объект.УказыватьПриПриемкеСобранныхКомплектов           = Истина;
		Объект.УказыватьПриПриемкеКомплектующихПослеРазборки    = Истина;
		Объект.УказыватьПриПриемкеПродукцииИзПроизводства       = Истина;
		
		Объект.УказыватьПриОтраженииИзлишков              = Истина;
		Объект.УказыватьПриОтраженииНедостач              = Истина;
		Объект.УказыватьПриПересчетеТоваров               = Истина;
		
		Объект.УказыватьПриПеремещенииМеждуПомещениями = Истина;
		
		
		Объект.УчетСерийВПереданныхНаКомиссиюТоваров       = Ложь;
		Объект.УчетСерийВНеотфактурованныхПоставкахТоваров = Ложь;
		Объект.УчетТоваровВПутиОтПоставщикаПоСериям        = Ложь;
		
	ИначеЕсли Объект.ТипПолитики = Перечисления.ТипыПолитикУказанияСерий.УчетСебестоимостиПоСериям Тогда
		Объект.УчетСерийПоFEFO                     = Ложь;
		Объект.УчитыватьСебестоимостьПоСериям = Истина;
		Объект.УчитыватьОстаткиСерий               = Истина;
		НастройкаУказанияСерийПриОтгрузке          = "ПриПланированииОтгрузки";
		
		Объект.УказыватьПриОтгрузке                       = Истина;
		Объект.УказыватьПриОтгрузкеКлиенту                = Истина;
		Объект.УказыватьПриОтгрузкеВРозницу               = Истина;
		Объект.УказыватьПриОтгрузкеКомплектующихДляСборки = Истина;
		Объект.УказыватьПриОтгрузкеНаВнутренниеНужды      = Истина;
		Объект.УказыватьПриОтгрузкеПоВозвратуПоставщику   = Истина;
		Объект.УказыватьПриОтгрузкеПоПеремещению          = Истина;
		Объект.УказыватьПриОтгрузкеКомплектовДляРазборки  = Истина;
		
		Объект.УказыватьПриПриемке                              = Истина;
		Объект.УказыватьПриПриемкеПоВозвратуОтКлиента           = Истина;
		Объект.УказыватьПриВозвратеНепринятыхПолучателемТоваров = Истина;
		Объект.УказыватьПриПриемкеОтПоставщика                  = Истина;
		Объект.УказыватьПриПриемкеПоПеремещению                 = Истина;
		Объект.УказыватьПриПриемкеПоПрочемуОприходованию        = Истина;
		Объект.УказыватьПриПриемкеСобранныхКомплектов           = Истина;
		Объект.УказыватьПриПриемкеКомплектующихПослеРазборки    = Истина;
		Объект.УказыватьПриПриемкеПродукцииИзПроизводства       = Истина;
		
		Объект.УказыватьПриОтраженииИзлишков              = Истина;
		Объект.УказыватьПриОтраженииНедостач              = Истина;
		Объект.УказыватьПриПересчетеТоваров               = Истина;
		
		Объект.УказыватьПриПеремещенииМеждуПомещениями = Истина;
		
		
		Объект.УчетСерийВПереданныхНаКомиссиюТоваров       = Ложь;
		Объект.УчетСерийВНеотфактурованныхПоставкахТоваров = Ложь;
		Объект.УчетТоваровВПутиОтПоставщикаПоСериям        = Ложь;
		
	КонецЕсли;
	
	ТипПолитикиПриИзмененииНаСервереЛокализация();
	
	НастроитьЭлементыФормыНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокТиповПолитик()
	
	ЭлементыТипаПолитик = Элементы.ТипПолитики.СписокВыбора;
	ЭлементыТипаПолитик.Очистить();
	
	Если ПолучитьФункциональнуюОпцию("БазоваяВерсия") Тогда
		ЭлементыТипаПолитик.Добавить(Перечисления.ТипыПолитикУказанияСерий.СправочноеУказаниеСерий);
		
		Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Объект.ТипПолитики = Перечисления.ТипыПолитикУказанияСерий.СправочноеУказаниеСерий;
			ТипПолитикиПриИзмененииНаСервере();
			
			Элементы.ТипПолитики.ТолькоПросмотр = Истина;
		ИначеЕсли Объект.ТипПолитики <> Перечисления.ТипыПолитикУказанияСерий.СправочноеУказаниеСерий Тогда
			ЭлементыТипаПолитик.Добавить(Объект.ТипПолитики);
		КонецЕсли;
	Иначе
		ПодсистемаГИСМ = ОбщегоНазначения.ПодсистемаСуществует("ГосИС.ГИСМ");
		
		Для Каждого ТипПолитики Из Перечисления.ТипыПолитикУказанияСерий Цикл
			Если ПодсистемаГИСМ
				Или ТипПолитики <> Перечисления.ТипыПолитикУказанияСерий.МаркировкаПродукцииДляГИСМ Тогда
				
				ЭлементыТипаПолитик.Добавить(ТипПолитики);
				
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Локализация

&НаСервере
Процедура НастроитьЭлементыФормыНаСервереЛокализация(ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач)
	
	//++ Локализация
	
	
	Если Объект.ТипПолитики = Перечисления.ТипыПолитикУказанияСерий.МаркировкаПродукцииДляГИСМ Тогда
		
		ПереходВИСМПВыполнен  = ИнтеграцияГИСМ.ПодсистемаНеИспользуется();
		
		Если ПереходВИСМПВыполнен Тогда
			Элементы.УказыватьПриПриемке.Доступность                              = Истина;
			Элементы.УказыватьПриПриемкеПоВозвратуОтКлиента.Доступность           = Объект.УказыватьПриПриемке;
		Иначе
			Элементы.УказыватьПриПриемке.Доступность                    = Ложь;
			Элементы.УказыватьПриПриемкеПоВозвратуОтКлиента.Доступность = Ложь;
		КонецЕсли;
		Элементы.УказыватьПриПриемкеПродукцииИзПроизводства.Доступность       = Объект.УказыватьПриПриемке;
		Элементы.УказыватьПриВозвратеНепринятыхПолучателемТоваров.Доступность = Объект.УказыватьПриПриемке;
		Элементы.УказыватьПриПриемкеОтПоставщика.Доступность                  = Объект.УказыватьПриПриемке;
		Элементы.УказыватьПриПриемкеПоПеремещению.Доступность                 = Объект.УказыватьПриПриемке;
		Элементы.УказыватьПриПриемкеСобранныхКомплектов.Доступность           = Объект.УказыватьПриПриемке;
		Элементы.УказыватьПриПриемкеКомплектующихПослеРазборки.Доступность    = Объект.УказыватьПриПриемке;
		Элементы.УказыватьПриПриемкеПоПрочемуОприходованию.Доступность        = Объект.УказыватьПриПриемке;
		
		Если ПереходВИСМПВыполнен Тогда
			Элементы.УказыватьПриОтгрузке.Доступность                     = Истина;
			Элементы.УказыватьПриОтгрузкеКлиенту.Доступность              = Объект.УказыватьПриОтгрузке;
			Элементы.УказыватьПриОтгрузкеВРозницу.Доступность             = Объект.УказыватьПриОтгрузке;
			Элементы.УказыватьПриОтгрузкеПоВозвратуПоставщику.Доступность = Объект.УказыватьПриОтгрузке;
			Элементы.УказыватьПриОтгрузкеНаВнутренниеНужды.Доступность    = Объект.УказыватьПриОтгрузке;
		Иначе
			Элементы.УказыватьПриОтгрузке.Доступность                     = Ложь;
			Элементы.УказыватьПриОтгрузкеКлиенту.Доступность              = Ложь;
			Элементы.УказыватьПриОтгрузкеВРозницу.Доступность             = Ложь;
			Элементы.УказыватьПриОтгрузкеПоВозвратуПоставщику.Доступность = Ложь;
			Элементы.УказыватьПриОтгрузкеНаВнутренниеНужды.Доступность    = Ложь;
		КонецЕсли;
		
		Элементы.УказыватьПриОтгрузкеКомплектующихДляСборки.Доступность = Объект.УказыватьПриОтгрузке;
		Элементы.УказыватьПриОтгрузкеПоПеремещению.Доступность          = Объект.УказыватьПриОтгрузке;
		Элементы.УказыватьПриОтгрузкеКомплектовДляРазборки.Доступность  = Объект.УказыватьПриОтгрузке;
		
		Элементы.УказыватьПриОтраженииИзлишков.Доступность              = ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач;
		Элементы.УказыватьПриПеремещенииМеждуПомещениями.Доступность    = Истина;
		Элементы.НастройкаУказанияСерийПриОтгрузке.Доступность          = Ложь;
		
		
		Элементы.УчетСерийВПереданныхНаХранениеТоварах.Доступность       = Ложь;
		Элементы.УчетСерийВПереданныхНаКомиссиюТоваров.Доступность       = Ложь;
		Элементы.УчетСерийВНеотфактурованныхПоставкахТоваров.Доступность = Ложь;
		Элементы.УчетТоваровВПутиОтПоставщикаПоСериям.Доступность        = Ложь;
		
	КонецЕсли;
	//-- Локализация
	
	Возврат;

КонецПроцедуры

&НаСервере
Процедура ТипПолитикиПриИзмененииНаСервереЛокализация()
	
	//++ Локализация
	Объект.УказыватьПриМаркировкеПродукцииДляГИСМ = Объект.ТипПолитики = Перечисления.ТипыПолитикУказанияСерий.МаркировкаПродукцииДляГИСМ;
	
	Если Объект.ТипПолитики = Перечисления.ТипыПолитикУказанияСерий.МаркировкаПродукцииДляГИСМ Тогда
		Объект.УчетСерийПоFEFO                     = Ложь;
		Объект.УчитыватьОстаткиСерий               = Ложь;
		Объект.УчитыватьСебестоимостьПоСериям      = Ложь;
		
		Объект.УказыватьПриОтгрузке                     = Истина;
		Объект.УказыватьПриОтгрузкеКлиенту              = Истина;
		Объект.УказыватьПриОтгрузкеВРозницу             = Истина;
		Объект.УказыватьПриОтгрузкеПоВозвратуПоставщику = Истина;
		Объект.УказыватьПриОтгрузкеНаВнутренниеНужды    = Истина;
		
		НастройкаУказанияСерийПриОтгрузке = "ПоФактуОтбора";
		
		Объект.УказыватьПриПриемке = Истина;
		Объект.УказыватьПриПриемкеОтПоставщика = Истина;
		Объект.УказыватьПриПриемкеПоВозвратуОтКлиента = Истина;
		Объект.УказыватьПриПриемкеПродукцииИзПроизводства = Истина;
		
		Объект.УказыватьПриМаркировкеПродукцииДляГИСМ = Истина;
		
		Объект.УказыватьПриПересчетеТоваров  = Ложь;
		Объект.УказыватьПриОтраженииНедостач = Ложь;
		
		Объект.УчетСерийВНеотфактурованныхПоставкахТоваров = Ложь;
		Объект.УчетТоваровВПутиОтПоставщикаПоСериям        = Ложь;
		
		Объект.УчетСерийВПереданныхНаКомиссиюТоваров = Ложь;
		
	КонецЕсли;
	//-- Локализация
	
	Возврат;

КонецПроцедуры

#КонецОбласти

#КонецОбласти
