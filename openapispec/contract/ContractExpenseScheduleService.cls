<?php
/**
 * File ContractExpenseScheduleService.cls contains the class ContractExpenseScheduleService
 *
 * @author    Jim Reed
 * @copyright 2000-2022 Intacct Corporation
 *
 * This document contains trade secret data that belongs to Intacct
 * Corporation and is protected by the copyright laws.  Information
 * herein may not be used, copied or disclosed in whole or in part
 * without prior written consent from Intacct Corporation.
 */

class ContractExpenseScheduleService extends ContractScheduleService
{
    protected function getScheduleEntityName(array $request): string
    {
        $entity = 'contractexpenseschedule';
        if (($request['JOURNAL'] ?? '') === 'J2') {
            $entity = 'contractexpense2schedule';
        }
        
        return $entity;
    }
    
    protected function getScheduleLineEntityName(array $request): string
    {
        return 'contractexpensescheduleentry';
    }
    
    public function post(array $request, array $extraContext): array
    {
        $result = parent::post($request, $extraContext);
        
        return ['STATUS' => 'completed', 'DETAILS' => $result['DETAILS']];
    }
}
