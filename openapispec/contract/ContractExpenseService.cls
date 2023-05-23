<?php
/**
 * File ContractExpenseService.cls contains the class ContractExpenseService
 *
 * @author    Vyshnavi Janakiram
 * @copyright 2000-2022 Intacct Corporation
 *
 * This document contains trade secret data that belongs to Intacct
 * Corporation and is protected by the copyright laws.  Information
 * herein may not be used, copied or disclosed in whole or in part
 * without prior written consent from Intacct Corporation.
 */

class ContractExpenseService
{

    const ENTITY = "contractexpense";

    /**
     * API Handler method to ContractExpense hold
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
            throw new APIInvalidFieldException($extraContext, 'Key', _('key is required'));
        }

        $contractExpenseKey = $request['KEY'];
        $asOfDate = $request['ASOFDATE'];

        $entity = self::ENTITY;
        $mgr = Globals::$g->gManagerFactory->getManager($entity);
        $result = $mgr->hold($contractExpenseKey, $asOfDate);

        if (!$result) {
            throw new APIExecutionException(_('Error in making expense hold.'));
        }

        return ['STATUS' => 'completed'];

    }

    /**
     * API Handler method to ContractExpense resume
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
            throw new APIInvalidFieldException($extraContext, 'Key', _('Contract Expense Key is required'));
        }

        $contractExpenseKey = $request['KEY'];
        $asOfDate = $request['ASOFDATE'];
        $entity = self::ENTITY;
        $mgr = Globals::$g->gManagerFactory->getManager($entity);
        $result = $mgr->resume($contractExpenseKey, $asOfDate);

        if (!$result) {
            throw new APIExecutionException(_('Error in making expense resume.'));
        }

        return ['STATUS' => 'completed'];

    }

    /**
     * API Handler method to ContractExpense post
     *
     * @param array    $request
     * @param array $extraContext
     *
     * @return array
     */
    public function post(array $request, array $extraContext): array
    {

        if (empty($request['KEY'])) {
            throw new APIInvalidFieldException($extraContext, 'Key', _('Contract Expense Key is required'));
        }

        $contractExpenseKey = $request['KEY'];
        $postMemo = $request['POSTMEMO'] ?? '';
        $glPostingDate = $request['GLPOSTINGDATE'] ?? '';


        $entity = self::ENTITY;
        $mgr = Globals::$g->gManagerFactory->getManager($entity);
        $result = $mgr->post($contractExpenseKey, $glPostingDate, $postMemo);

        if (!$result) {
            throw new APIExecutionException(_('Error in posting expense.'));
        }

        return ['STATUS' => 'completed'];

    }

}
