<?php
/**
 * File ContractScheduleService.cls contains the class ContractScheduleService
 *
 * @author    Jim Reed
 * @copyright 2000-2022 Intacct Corporation
 *
 * This document contains trade secret data that belongs to Intacct
 * Corporation and is protected by the copyright laws.  Information
 * herein may not be used, copied or disclosed in whole or in part
 * without prior written consent from Intacct Corporation.
 */

abstract class ContractScheduleService
{
    abstract protected function getScheduleEntityName(array $request): string;
    
    abstract protected function getScheduleLineEntityName(array $request): string;
    
    /** @noinspection PhpUnusedParameterInspection */
    public function post(array $request, array $extraContext): array
    {
        if (empty($request['JOURNAL'])) {
            throw new APIInvalidFieldException($extraContext, 'JOURNAL', _('Journal is required'));
        }
        
        if (empty($request['ASOFDATE']) && empty($request['SCHEDULEENTRIES'])) {
            throw new APIInvalidFieldException($extraContext, 'ASOFDATE', _('asOfDate is required'));
        }
        
        if (empty($request['CUSTOMERKEY']) && empty($request['CONTRACTKEY']) && empty($request['SCHEDULEENTRIES'])) {
            throw new APIInvalidFieldException(
                $extraContext,
                'CUSTOMERKEY',
                _('customerKey, contractKey or scheduleLineKeys are required')
            );
        }
        
        $asOfDate = $request['ASOFDATE'] ?? GetCurrentDate();
        $scheduleEntryKeys = empty($request['SCHEDULEENTRIES']) ? [] : array_column($request['SCHEDULEENTRIES'], 'SCHEDULEENTRYKEY');
        $postingDate = $request['POSTINGDATE'] ?? '';
        $customerKey = $request['CUSTOMERKEY'] ?? '';
        $contractKey = $request['CONTRACTKEY'] ?? '';
        
        $entity = $this->getScheduleEntityName($request);
        /** @var ContractRevenueScheduleManager|ContractExpenseScheduleManager $mgr */
        $mgr = Globals::$g->gManagerFactory->getManager($entity);
        $result = $mgr->postKeys($asOfDate, $postingDate, $customerKey, $contractKey, $scheduleEntryKeys);
        
        return $result;
    }
    
    /** @noinspection PhpUnusedParameterInspection */
    public function reallocate(array $request, array $extraContext): array
    {
        if (empty($request['JOURNAL'])) {
            throw new APIInvalidFieldException($extraContext, 'JOURNAL', _('Journal is required'));
        }

        if (empty($request['SCHEDULEKEY'])) {
            throw new APIInvalidFieldException($extraContext, 'SCHEDULEKEY', _('scheduleKey is required'));
        }
        
        if (empty($request['STARTDATE'])) {
            throw new APIInvalidFieldException($extraContext, 'STARTDATE', _('startDate is required'));
        }
        
        if (empty($request['ENDDATE'])) {
            throw new APIInvalidFieldException($extraContext, 'ENDDATE', _('endDate is required'));
        }
        
        $schedulekey = $request['SCHEDULEKEY'] ?? '';
        $stardate = $request['STARTDATE'] ?? '';
        $enddate = $request['ENDDATE'] ?? '';
        $postPastDated = empty($request['POSTPASTDATED']) ? 'false' : 'true';
        
        $entity = $this->getScheduleEntityName($request);
        /** @var ContractRevenueScheduleManager|ContractExpenseScheduleManager $mgr */
        $mgr = Globals::$g->gManagerFactory->getManager($entity);
        $ok = $mgr->reallocate($schedulekey, $stardate, $enddate, $postPastDated);
        
        if (!$ok) {
            throw new APIExecutionException(_('Error reallocating schedule(s).'));
        }
        
        return ['STATUS' => 'completed'];
    }
    
    /** @noinspection PhpUnusedParameterInspection */
    public function postLine(array $request, array $extraContext): array
    {
        if (empty($request['RECORDNO'])) {
            throw new APIInvalidFieldException($extraContext, 'RECORDNO', _('scheduleLineKey is required'));
        }
        
        $recordNo = $request['RECORDNO'] ?? '';
        $postingDate = $request['POSTINGDATE'] ?? '';
        
        $entity = $this->getScheduleLineEntityName($request);
        /** @var ContractRevenueScheduleEntryManager|ContractExpenseScheduleEntryManager $mgr */
        $mgr = Globals::$g->gManagerFactory->getManager($entity);
        $ok = $mgr->post($recordNo, $postingDate);
        
        if (!$ok) {
            throw new APIExecutionException(_('Error posting schedule line.'));
        }
        
        return ['STATUS' => 'completed'];
    }
    
    /** @noinspection PhpUnusedParameterInspection */
    public function unPostLine(array $request, array $extraContext): array
    {
        if (empty($request['RECORDNO'])) {
            throw new APIInvalidFieldException($extraContext, 'RECORDNO', _('scheduleLineKey is required'));
        }
        
        $recordNo = $request['RECORDNO'] ?? '';
        
        $entity = $this->getScheduleLineEntityName($request);
        /** @var ContractRevenueScheduleEntryManager|ContractExpenseScheduleEntryManager $mgr */
        $mgr = Globals::$g->gManagerFactory->getManager($entity);
        $ok = $mgr->unpost($recordNo);
        
        if (!$ok) {
            throw new APIExecutionException(_('Error unposting schedule line.'));
        }
        
        return ['STATUS' => 'completed'];
    }
}
