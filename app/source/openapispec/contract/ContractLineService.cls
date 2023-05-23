<?php
/**
 * File ContractLineService.cls contains the class ContractLineService
 *
 * @author    Niraj Kumar
 * @copyright 2000-2022 Intacct Corporation
 *
 * This document contains trade secret data that belongs to Intacct
 * Corporation and is protected by the copyright laws.  Information
 * herein may not be used, copied or disclosed in whole or in part
 * without prior written consent from Intacct Corporation.
 */

class ContractLineService
{
   
    const ENTITY = "contractdetail";

    /**
     * API Handler method to ContractDetail hold
     *
     * @param array    $request
     * @param array $extraContext
     *
     * @return array
     */
    public function hold(array $request, array $extraContext): array
    {
        
        if (empty($request['ASOFDATE'])) {
            throw new APIInvalidFieldException($extraContext, 'ASOFDATE', _('asOfDate is required'));
        }

        if (empty($request['KEY'])) {
            throw new APIInvalidFieldException($extraContext, 'KEY', _('key is required'));
        }
        
        $contractDetailKey = $request['KEY'];
        $asOfDate = $request['ASOFDATE'];
        $memo = $request['MEMO'] ?? '';
        $holdBillingSchedule = $request['BILLING'] ?? '';
        $holdRevenueSchedule = $request['REVENUE'] ?? '';
        $holdExpenseSchedule = $request['EXPENSE'] ?? '';
        
        $entity = self::ENTITY;
        $mgr = Globals::$g->gManagerFactory->getManager($entity);
        $result = $mgr->hold($contractDetailKey, $asOfDate, $memo, $holdBillingSchedule, $holdRevenueSchedule, $holdExpenseSchedule);

        if (!$result) {
            throw new APIExecutionException(_('Error in making line hold.'));
        }

        return ['STATUS' => 'completed'];
        
    }

    /**
     * API Handler method to ContractDetail resume
     *
     * @param array    $request
     * @param array $extraContext
     *
     * @return array
     */
    public function resume(array $request, array $extraContext): array
    {
        
        if (empty($request['ASOFDATE'])) {
            throw new APIInvalidFieldException($extraContext, 'ASOFDATE', _('asOfDate is required'));
        }

        if (empty($request['KEY'])) {
            throw new APIInvalidFieldException($extraContext, 'Key', _('Contract Line Key is required'));
        }

        $contractDetailKey = $request['KEY'];
        $asOfDate = $request['ASOFDATE'];
        $memo = $request['MEMO'] ?? '';
        $resumeBillingSchedule = $request['BILLING'] ?? '';
        $resumeRevenueSchedule = $request['REVENUE'] ?? '';
        $resumeExpenseSchedule = $request['EXPENSE'] ?? '';
        $adjustmentType =  $request['REVENUEADJUSTMENTTYPE'] ?? '';
            
        $entity = self::ENTITY;
        $mgr = Globals::$g->gManagerFactory->getManager($entity);
        $result = $mgr->resume($contractDetailKey, $asOfDate, $memo, $resumeBillingSchedule, $resumeRevenueSchedule, $resumeExpenseSchedule, $adjustmentType);

        if (!$result) {
            throw new APIExecutionException(_('Error in making line resume.'));
        }

        return ['STATUS' => 'completed'];

    }

    /**
     * API Handler method to ContractDetail deliver
     *
     * @param array    $request
     * @param array $extraContext
     *
     * @return array
     */
    public function deliver(array $request, array $extraContext): array
    {
        
        if (empty($request['DELIVERYDATE'])) {
            throw new APIInvalidFieldException($extraContext, 'deliveryDate', _('deliveryDate is required'));
        }

        if (empty($request['KEY'])) {
            throw new APIInvalidFieldException($extraContext, 'Key', _('Contract Line Key is required'));
        }

        $contractDetailKey = $request['KEY'];
        $deliveryDate = $request['DELIVERYDATE'];
        
        $entity = self::ENTITY;
        $mgr = Globals::$g->gManagerFactory->getManager($entity);
        $result = $mgr->deliver($contractDetailKey, $deliveryDate);

        if (!$result) {
            throw new APIExecutionException(_('Error delivering line.'));
        }

        return ['STATUS' => 'completed'];

    }

    /**
     * API Handler method to ContractDetail Uncancel
     *
     * @param array    $request
     * @param array $extraContext
     *
     * @return array
     */
    public function uncancel(array $request, array $extraContext): array
    {
        
        if (empty($request['KEY'])) {
            throw new APIInvalidFieldException($extraContext, 'Key', _('Contract Line Key is required'));
        }

        $contractDetailKey = $request['KEY'];


        $entity = self::ENTITY;
        $mgr = Globals::$g->gManagerFactory->getManager($entity);
        $result = $mgr->uncancel($contractDetailKey);

        if (!$result) {
            throw new APIExecutionException(_('Error uncanceling line.'));
        }

        return ['STATUS' => 'completed'];

    }

    /**
     * API Handler method to ContractDetail Post
     *
     * @param array    $request
     * @param array $extraContext
     *
     * @return array
     */
    public function post(array $request, array $extraContext): array
    {

        if (empty($request['KEY'])) {
            throw new APIInvalidFieldException($extraContext, 'Key', _('Contract Line Key is required'));
        }

        $contractDetailKey = $request['KEY'];
        $postMemo = $request['POSTMEMO'] ?? '';
        $glPostingDate = $request['POSTINGDATE'] ?? '';
 

        $entity = self::ENTITY;
        $mgr = Globals::$g->gManagerFactory->getManager($entity);
        $result = $mgr->post($contractDetailKey, $glPostingDate, $postMemo);

        if (!$result) {
            throw new APIExecutionException(_('Error posting line.'));
        }

        return ['STATUS' => 'completed'];

    }
  
}
