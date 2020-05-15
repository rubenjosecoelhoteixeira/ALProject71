pageextension 50010 CreditLimitExt extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("F&unctions")
        {
            action(UpdateCreditLimit)
            {
                Caption = 'Update Credit Limit';
                Image = CalculateCost;
                trigger OnAction()
                begin
                    CallUpdateCreditLimit();
                end;

            }
        }
    }


    procedure CallUpdateCreditLimit()
    var
        CreditLimitCalculated: Decimal;
        CreditLimitActual: Decimal;
    begin
        CreditLimitCalculated := Rec.CalculateCreditLimit();
        if CreditLimitCalculated = Rec."Credit Limit (LCY)" then begin
            Message(CreditLimitUpToDateTxt);
            exit;
        end;
        if GuiAllowed() then
            if not Confirm(AreYouSureQst, false, FieldCaption("Credit Limit (LCY)"), CreditLimitCalculated) then
                exit;
        CreditLimitActual := CreditLimitCalculated;
        Rec.UpdateCreditLimit(CreditLimitActual);
        if CreditLimitActual <> CreditLimitCalculated then
            Message(CreditLimitRoundedTxt, CreditLimitActual);
    end;

    var
        AreYouSureQst: Label 'Are you sure that you want to set the %1 to %2?';
        CreditLimitRoundedTxt: Label 'The credit limit was rounded to %1 to comply with company policies.';
        CreditLimitUpToDateTxt: Label 'The credit limit is up to date.';
}