<?php
/**
 * File ContractRevenueScheduleService.cls contains the class ContractRevenueScheduleService
 *
 * @author    Jim Reed
 * @copyright 2000-2022 Intacct Corporation
 *
 * This document contains trade secret data that belongs to Intacct
 * Corporation and is protected by the copyright laws.  Information
 * herein may not be used, copied or disclosed in whole or in part
 * without prior written consent from Intacct Corporation.
 */

class ContractRevenueScheduleService extends ContractScheduleService
{
    protected function getScheduleEntityName(array $request): string
    {
        $entity = 'contractrevenueschedule';
        if (($request['JOURNAL'] ?? '') === 'J2') {
            $entity = 'contractrevenue2schedule';
        }
        
        return $entity;
    }
    
    protected function getScheduleLineEntityName(array $request): string
    {
        return 'contractrevenuescheduleentry';
    }
    
    public function post(array $request, array $extraContext): array
    {
        $result = parent::post($request, $extraContext);
        
        if ($result['SUCCESS'] === false) {
            throw new APIExecutionException(_('Error posting schedule(s).'));
        }
        
        return ['STATUS' => 'completed', 'DETAILS' => $result['DETAILS']];
    }
}
